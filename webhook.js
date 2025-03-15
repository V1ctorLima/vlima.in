const http = require('http');
const crypto = require('crypto');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const PORT = process.env.WEBHOOK_PORT || 9000;
const SECRET_FILE = path.join(__dirname, '.webhook-secret');
const BRANCH = process.env.WEBHOOK_BRANCH || 'main';

// Load the webhook secret from file
let webhookSecret;
try {
  webhookSecret = fs.readFileSync(SECRET_FILE, 'utf8').trim();
} catch (err) {
  console.error('Error loading webhook secret. Please create a .webhook-secret file with your GitHub webhook secret.');
  console.error('You can generate a random secret with: node -e "console.log(require(\'crypto\').randomBytes(20).toString(\'hex\'))"');
  process.exit(1);
}

// Create the server
const server = http.createServer((req, res) => {
  // Only accept POST requests to /webhook
  if (req.method !== 'POST' || req.url !== '/webhook') {
    res.statusCode = 404;
    res.end('Not Found');
    return;
  }

  // Get the signature from the headers
  const signature = req.headers['x-hub-signature-256'];
  if (!signature) {
    console.error('No signature provided');
    res.statusCode = 401;
    res.end('Unauthorized');
    return;
  }

  // Collect the request body
  let body = [];
  req.on('data', chunk => {
    body.push(chunk);
  });

  req.on('end', () => {
    body = Buffer.concat(body).toString();
    
    // Verify the signature
    const hmac = crypto.createHmac('sha256', webhookSecret);
    const digest = 'sha256=' + hmac.update(body).digest('hex');
    
    if (signature !== digest) {
      console.error('Invalid signature');
      res.statusCode = 401;
      res.end('Unauthorized');
      return;
    }

    // Parse the payload
    let payload;
    try {
      payload = JSON.parse(body);
    } catch (err) {
      console.error('Invalid JSON payload');
      res.statusCode = 400;
      res.end('Bad Request');
      return;
    }

    // Check if it's a push event to the specified branch
    if (payload.ref !== `refs/heads/${BRANCH}`) {
      console.log(`Ignoring push to ${payload.ref}, only watching ${BRANCH}`);
      res.statusCode = 200;
      res.end('OK');
      return;
    }

    console.log(`Received push to ${BRANCH}, deploying...`);
    
    // Run the deployment script with the auto-update flag
    exec('./deploy.sh --auto-update', (error, stdout, stderr) => {
      if (error) {
        console.error(`Deployment error: ${error.message}`);
        console.error(stderr);
        res.statusCode = 500;
        res.end('Deployment Failed');
        return;
      }
      
      console.log('Deployment output:');
      console.log(stdout);
      
      res.statusCode = 200;
      res.end('Deployment Successful');
    });
  });
});

// Start the server
server.listen(PORT, () => {
  console.log(`Webhook server listening on port ${PORT}`);
  console.log(`Watching for pushes to ${BRANCH} branch`);
}); 