---
title: "How to deploy an efficienty Signal Similarity Model"
date: "2025-06-28"
slug: "how-to-deploy-an-efficienty-signal-similarity-model"
description: "TBD."
tags: [cybersecurity, blue-team, career]
---

<InfoPanel title="Warning">
This blog doesn't focus in RAG or LLMs techniques, but actually uses deterministic algoritm to find the correlation amoung the text.
</InfoPanel>

<InfoPanel title="Information">
**TL;DR** By using tran cosine correlation.
</InfoPanel>

## What will be presented today

Most of the ideas 


# Problem Statement

## 1 - We are losing Context from Rotations

<img src="19c7eda3-376e-46e8-bbe2-05a7869944ce.png" width="700" aligh="center"/>


## MinHash + Jaccard Similarity

In computer science and data mining, MinHash (or the min-wise independent permutations locality sensitive hashing scheme) is a technique for quickly estimating how similar two sets are. It has also been applied in large-scale clustering problems, such as clustering documents by the similarity of their sets of words.[1]

**FUN FACT:** Initially used in the AltaVista search engine to detect duplicate web pages and eliminate them from search results.[2] 

### Advantages:
 - MinHash is a technique for estimating the Jaccard similarity between sets, making it suitable for detecting similarity between documents even when the wording differs.
 - It is memory-efficient, as it only requires storing a fixed-size signature for each document regardless of its length or the size of the vocabulary.
 - MinHash can be combined with locality-sensitive hashing (LSH) for efficient similarity search in large datasets.
### Disadvantages:
 - MinHash is less interpretable compared to TF-IDF. The resulting MinHash signatures are opaque and not directly interpretable as words or phrases.
 - It may not capture fine-grained differences between documents, especially if they have similar sets of words but differ in their frequencies or ordering.

![image.png](8411add3-a12b-453f-a027-e891b5c882ed.png)


```python
from datasketch import MinHash

data1 = ['Empowering', 'Personio', 'to', 'achieve', 'its', 'business', 'goals',
        'in', 'a', 'manner', 'and', 'customer', 'assurance', 'in', 'the', 'protection',
        'of', 'their', 'data']
data2 = ['Empowering', 'Personio', 'to', 'achieve', 'its', 'business', 'goals',
        'in', 'a', 'manner', 'and', 'customer', 'assurance', 'in', 'the', 'protection',
        'of', 'their', 'data']
# data2 = ['achieve', 'its', 'business', 'in', 'a', 'manner', 'and',  'the', 'protection',
#         'customer', 'assurance', 'in', 'Empowering', 'to',  'goals',
#         'of', 'their', 'data','Personio']
# data2 = ['achieve', 'achieve', 'achieve', 'achieve', 'achieve', 'achieve', 'achieve', 'achieve', 'achieve',
#          'Empowering', 'Personio', 'to', 'achieve', 'its', 'business', 'goals',
#         'in', 'a', 'manner', 'and', 'customer', 'assurance', 'in', 'the', 'protection',
#         'of', 'their', 'data']
# data2 = ['Empowering', 'Personio', 'to', 'achieve', 'its', 'business', 'goals']

m1, m2 = MinHash(), MinHash()
for d in data1:
    m1.update(d.encode('utf8'))
for d in data2:
    m2.update(d.encode('utf8'))
print("Estimated Jaccard for data1 and data2 is", m1.jaccard(m2))

s1 = set(data1)
s2 = set(data2)
actual_jaccard = float(len(s1.intersection(s2)))/float(len(s1.union(s2)))
print("Actual Jaccard for data1 and data2 is", actual_jaccard)
```

    Estimated Jaccard for data1 and data2 is 1.0
    Actual Jaccard for data1 and data2 is 1.0