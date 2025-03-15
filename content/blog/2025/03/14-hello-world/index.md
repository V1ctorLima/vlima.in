---
title: "Using Custom Panels in Markdown"
date: "2025-05-20"
slug: "using-panels-in-markdown"
description: "Learn how to use custom panels in your Markdown content to highlight important information."
tags: [cybersecurity, blue-team, career]
---

# Using Custom Panels in Markdown

This guide shows you how to use custom panels in your Markdown content to highlight important information, warnings, notes, and more.

## Available Panel Types

This blog supports several types of panels that you can use in your Markdown content:

### Info Panel

Use the Info Panel to provide additional information or context.

<InfoPanel title="Information">
This is an information panel. Use it to provide additional context or details about a topic.
</InfoPanel>

```jsx
<InfoPanel title="Information">
This is an information panel. Use it to provide additional context or details about a topic.
</InfoPanel>
```

### Warning Panel

Use the Warning Panel to highlight potential issues or things to be careful about.

<WarningPanel title="Be Careful">
This is a warning panel. Use it to alert readers about potential issues or things to be careful about.
</WarningPanel>

```jsx
<WarningPanel title="Be Careful">
This is a warning panel. Use it to alert readers about potential issues or things to be careful about.
</WarningPanel>
```

### Danger Panel

Use the Danger Panel for critical warnings or serious issues.

<DangerPanel title="Critical Warning">
This is a danger panel. Use it for critical warnings or serious issues that require immediate attention.
</DangerPanel>

```jsx
<DangerPanel title="Critical Warning">
This is a danger panel. Use it for critical warnings or serious issues that require immediate attention.
</DangerPanel>
```

### Success Panel

Use the Success Panel to highlight positive outcomes or best practices.

<SuccessPanel title="Best Practice">
This is a success panel. Use it to highlight positive outcomes, best practices, or successful approaches.
</SuccessPanel>

```jsx
<SuccessPanel title="Best Practice">
This is a success panel. Use it to highlight positive outcomes, best practices, or successful approaches.
</SuccessPanel>
```

### Note Panel

Use the Note Panel for side notes or additional thoughts.

<NotePanel title="Side Note">
This is a note panel. Use it for side notes, additional thoughts, or supplementary information.
</NotePanel>

```jsx
<NotePanel title="Side Note">
This is a note panel. Use it for side notes, additional thoughts, or supplementary information.
</NotePanel>
```

## Using Panels Without Titles

You can also use panels without titles if you prefer:

<InfoPanel>
This information panel doesn't have a title.
</InfoPanel>

```jsx
<InfoPanel>
This information panel doesn't have a title.
</InfoPanel>
```

## Using the Generic Panel Component

If you want more control, you can use the generic `Panel` component and specify the type:

<Panel type="info" title="Custom Panel">
This is a custom panel using the generic Panel component.
</Panel>

```jsx
<Panel type="info" title="Custom Panel">
This is a custom panel using the generic Panel component.
</Panel>
```

## Panels with Markdown Content

Panels can contain Markdown content, including:

<InfoPanel title="Rich Content">
- **Bold text**
- *Italic text*
- [Links](https://example.com)
- Lists
  - Nested items
  - More nested items
- And more!
</InfoPanel>

```jsx
<InfoPanel title="Rich Content">
- **Bold text**
- *Italic text*
- [Links](https://example.com)
- Lists
  - Nested items
  - More nested items
- And more!
</InfoPanel>
```

## Conclusion

Using panels in your Markdown content can help highlight important information and make your content more engaging and easier to scan. Try incorporating them in your next blog post! 