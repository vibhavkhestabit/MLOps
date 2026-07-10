# Open Source License Handbook

> "Understanding software licenses is not about memorizing legal text. It is about understanding the philosophy behind each license, the freedoms it grants, the obligations it imposes, and when it is appropriate to use."

---

# Table of Contents

1. Introduction
2. MIT License
3. BSD License
4. Apache License 2.0
5. LGPL
6. MPL 2.0
7. GPL v2 / GPL v3
8. AGPL
9. Choosing the Right License
10. Real World Open Source Projects
11. License Compatibility
12. Enterprise License Compliance
13. Quick Cheat Sheet

---

# 1. Introduction

In the previous document, we studied the fundamentals of software licensing, including:

- Copyright vs License
- Proprietary vs Open Source
- Source Available Software
- Permissive Licensing
- Weak Copyleft
- Strong Copyleft
- Redistribution
- Derivative Works
- Patent Grants

Now, we will study the licenses themselves.

Each license exists because software authors have different goals.

Some authors want:

- Maximum adoption
- Minimal restrictions
- Commercial usage
- Simple legal requirements

Others want:

- Community contributions
- Software freedom to continue
- Improvements to remain open source
- Protection against proprietary redistribution

These goals influence the choice of license.

---

## Categories Covered

### Permissive Licenses

- MIT
- BSD
- Apache 2.0

These licenses prioritize flexibility and adoption.

---

### Weak Copyleft

- LGPL
- MPL 2.0

These licenses protect the licensed component while allowing greater flexibility for larger applications.

---

### Strong Copyleft

- GPL
- AGPL

These licenses are designed to preserve software freedoms for future recipients by imposing stronger obligations when software is distributed (or, in AGPL's case, made available over a network).

---

# 2. MIT License

## Overview

The MIT License is the most widely used open-source software license in the world.

It is known for its simplicity, flexibility, and minimal legal requirements.

Its philosophy can be summarized in one sentence:

> "Take my software, do almost anything you want with it, just don't remove my copyright and license."

Because of this simplicity, MIT has become the preferred choice for thousands of libraries, frameworks, developer tools, and startups.

---

## History

The MIT License originated at the Massachusetts Institute of Technology (MIT).

It was designed to be:

- Short
- Easy to understand
- Easy to comply with
- Friendly for commercial software

Unlike many modern licenses, MIT avoids lengthy legal language and focuses only on the essential permissions and obligations.

Today it is one of the most recognized open-source licenses.

---

# Philosophy

The MIT License is based on a simple belief:

> "Software becomes more valuable when as many people as possible are free to use it."

The author does not attempt to control how the software is used after it is released.

Instead, the author trusts users to build whatever they want, whether it is:

- Open-source software
- Commercial software
- Internal company tools
- Enterprise products
- SaaS applications

The only expectation is that proper credit is preserved.

---

# Permissions

The MIT License grants extremely broad permissions.

A user may:

✅ Use the software

✅ Copy the software

✅ Modify the source code

✅ Merge it into another project

✅ Publish it

✅ Redistribute it

✅ Sell software containing it

✅ Use it commercially

✅ Include it in proprietary applications

This is why MIT is called a **permissive license**.

---

# Obligations

Although MIT is very flexible, it is **not** "no rules."

Users must:

- Preserve the original copyright notice.
- Include the MIT License text when redistributing the software or substantial portions of it.

That's essentially it.

There is **no requirement** to:

- Publish your own source code.
- Use the MIT License for your own project.
- Open-source your application.
- Contribute changes back to the original project.

---

# Commercial Use

One of the biggest strengths of MIT is that it fully supports commercial software.

A company may:

```
Download MIT Project

↓

Modify It

↓

Combine It With Proprietary Code

↓

Sell Product

↓

Keep Their Own Source Code Private
```

This is completely allowed, provided the copyright notice and license text are preserved.

---

# Redistribution

MIT allows redistribution in almost any form.

Examples include:

- Publishing the original project on GitHub.
- Creating a modified version.
- Shipping a desktop application.
- Selling commercial software.
- Publishing a mobile application.
- Including the code in an enterprise product.

When redistributing, the original copyright notice and MIT License text must remain with the software.

---

# Patent Position

One important limitation of the MIT License is that it **does not include an explicit patent grant**.

This does **not** mean patents are prohibited.

It simply means the license does not expressly grant users patent rights from contributors.

For many individual developers and startups, this is not an issue.

For large organizations, however, explicit patent protection can be valuable.

This is one reason why many enterprise projects choose Apache License 2.0 instead.

---

# Advantages

The MIT License is popular because it is:

- Extremely easy to understand.
- Very short.
- Commercial-friendly.
- Easy to integrate with other software.
- Compatible with many development ecosystems.
- Attractive to startups and enterprises alike.

It encourages rapid adoption because developers rarely need extensive legal review before using MIT-licensed software.

---

# Limitations

The flexibility of MIT also means the original author gives up some control.

For example:

A company may:

- Improve the software.
- Build a commercial product.
- Keep all improvements private.
- Never contribute those improvements back.

This is allowed under MIT.

Some authors are comfortable with this because they prioritize adoption.

Others prefer copyleft licenses that encourage improvements to remain available to the community.

---

# Common Misconceptions

### "MIT means public domain."

❌ Incorrect.

The software is still protected by copyright.

The license simply grants broad permissions.

---

### "MIT has no rules."

❌ Incorrect.

Users must preserve:

- Copyright notice
- License text

---

### "MIT software cannot be sold."

❌ Incorrect.

Commercial use is fully permitted.

Many billion-dollar companies use MIT-licensed software.

---

### "Using MIT code forces my project to become MIT."

❌ Incorrect.

Your own project may use a different license.

You only need to comply with the MIT License for the MIT-licensed portions.

---

# Real-World Projects

Many popular projects use the MIT License, including:

- React
- Next.js
- Express
- Vite
- Tailwind CSS
- Electron
- Axios
- Lodash

These projects chose MIT because they wanted the lowest possible barrier to adoption.

---

# When Should You Choose MIT?

The MIT License is an excellent choice when you want:

- Maximum adoption.
- Simple legal requirements.
- Broad commercial use.
- Easy integration with proprietary software.
- Minimal compliance burden.

It is especially suitable for:

- Libraries
- Frameworks
- Developer tools
- SDKs
- Utility packages
- Personal open-source projects

---

# Summary

The MIT License is the simplest and most permissive of the widely used open-source licenses.

It grants users extensive freedom to use, modify, and redistribute software—including in proprietary commercial products—while imposing only two primary obligations:

- Preserve the copyright notice.
- Include the MIT License text.

Because of its simplicity and flexibility, MIT has become one of the most widely adopted software licenses in modern software development.

# 3. BSD License

## Overview

The BSD (Berkeley Software Distribution) License is one of the oldest and most respected open-source licenses.

It is a **permissive license**, meaning it allows users to freely use, modify, and redistribute software with very few restrictions.

In practice, BSD behaves very similarly to the MIT License.

For most developers, choosing between MIT and BSD rarely affects how they use the software. The main differences lie in the wording of the license and a few additional clauses.

---

# History

The BSD License originated at the **University of California, Berkeley** during the development of the Berkeley Software Distribution (BSD), a Unix operating system developed in the late 1970s and 1980s.

Many technologies that power today's internet—including networking components and operating system features—trace their roots back to BSD.

Because of its long history, BSD became one of the earliest and most influential open-source licenses.

---

# Philosophy

Like the MIT License, BSD prioritizes:

- Maximum adoption
- Simplicity
- Commercial use
- Minimal legal obligations

The philosophy can be summarized as:

> "Use my software however you like, but preserve the required notices and don't misrepresent who created it."

BSD was created to encourage software sharing while ensuring that the original authors continued to receive proper credit.

---

# Versions of BSD

There are three commonly discussed BSD licenses.

## BSD 2-Clause ("Simplified BSD")

The BSD 2-Clause License is very close to the MIT License.

It allows:

- Commercial use
- Modification
- Redistribution
- Proprietary software

The only significant obligations are:

- Keep the copyright notice.
- Keep the license text.

Because of its simplicity, BSD 2-Clause is often considered almost interchangeable with MIT for many projects.

---

## BSD 3-Clause ("New BSD")

BSD 3-Clause includes everything found in BSD 2-Clause, plus one additional requirement:

### Non-Endorsement Clause

The names of the original authors or organization cannot be used to promote or endorse your product without permission.

For example:

Suppose you build a commercial application using BSD 3-Clause software.

You **cannot** advertise your product by saying:

> "Approved by the University of California."

unless the University has actually granted permission.

This clause protects the reputation of the original authors.

---

## BSD 4-Clause (Historical)

An older version called BSD 4-Clause included an advertising requirement that forced developers to acknowledge the original project in advertising materials.

This clause became unpopular because it created unnecessary compliance work.

As a result, BSD 4-Clause is now rarely used.

Modern projects almost always use BSD 2-Clause or BSD 3-Clause.

---

# Permissions

Like MIT, BSD allows users to:

✅ Use the software

✅ Copy the software

✅ Modify the software

✅ Redistribute the software

✅ Use it commercially

✅ Include it in proprietary applications

No source code sharing is required.

No copyleft obligations exist.

---

# Obligations

BSD licenses have only a few obligations.

Users generally must:

- Preserve the copyright notice.
- Preserve the license text.
- Follow the non-endorsement clause if using BSD 3-Clause.

There is **no requirement** to:

- Publish source code.
- Open-source your application.
- Use the BSD License for your own project.
- Contribute modifications back to the community.

---

# Commercial Use

BSD is fully compatible with commercial software development.

A company may:

```
BSD Library

↓

Modify

↓

Combine with Proprietary Code

↓

Sell Commercial Product

↓

Keep Their Own Source Code Private
```

This is completely allowed.

---

# Patent Position

Like the MIT License, BSD licenses **do not include an explicit patent grant**.

This means they provide copyright permissions but do not expressly grant patent rights from contributors.

Projects that require explicit patent protection often choose Apache License 2.0 instead.

---

# Advantages

The BSD License is popular because it is:

- Very simple
- Easy to understand
- Commercial-friendly
- Legally lightweight
- Compatible with proprietary software
- Highly compatible with other permissive licenses

Many operating systems and networking projects have historically chosen BSD because of these characteristics.

---

# Limitations

Because BSD is permissive:

- Companies may keep improvements private.
- Proprietary forks are allowed.
- Community contributions are voluntary.

Just like MIT, BSD prioritizes adoption over requiring improvements to be shared.

---

# MIT vs BSD

For most software developers, MIT and BSD behave almost identically.

The major practical difference is the **BSD 3-Clause Non-Endorsement Clause**.

| Feature | MIT | BSD 2-Clause | BSD 3-Clause |
|----------|-----|--------------|--------------|
| Commercial Use | ✅ | ✅ | ✅ |
| Modification | ✅ | ✅ | ✅ |
| Proprietary Software | ✅ | ✅ | ✅ |
| Copyright Notice | ✅ | ✅ | ✅ |
| License Text | ✅ | ✅ | ✅ |
| Patent Grant | ❌ | ❌ | ❌ |
| Non-Endorsement Clause | ❌ | ❌ | ✅ |

---

# Real-World Projects

Many important projects use BSD licenses, including:

- FreeBSD
- OpenBSD
- NetBSD
- LLVM
- libc++
- OpenSSH (BSD-style license)
- Chromium (contains BSD-licensed components)

These projects chose BSD because it encourages widespread adoption while remaining legally simple.

---

# When Should You Choose BSD?

Choose BSD when you want:

- A permissive license similar to MIT.
- Broad commercial adoption.
- Very few legal obligations.
- Freedom for users to build proprietary software.
- An optional non-endorsement clause (BSD 3-Clause).

Many organizations choose BSD simply because it has a long history and is trusted within systems programming and operating system communities.

---

# Summary

The BSD License is one of the oldest permissive open-source licenses.

For everyday software development, it behaves almost the same as the MIT License:

- Broad permissions
- Commercial-friendly
- No copyleft
- No source code sharing requirement

The only major distinction is that **BSD 3-Clause adds a Non-Endorsement Clause**, preventing users from implying that the original authors endorse their products.

For most developers, choosing between MIT and BSD is largely a matter of project preference rather than functionality.

# 4. Apache License 2.0

## Overview

The Apache License 2.0 is a **permissive open-source license** created by the Apache Software Foundation (ASF).

Like the MIT and BSD licenses, it allows developers to:

- Use software
- Modify software
- Redistribute software
- Use it commercially
- Include it in proprietary applications

However, Apache 2.0 adds several important legal protections that make it particularly attractive for enterprise software and large collaborative projects.

The most significant additions are:

- Explicit Patent Grant
- Patent Termination Clause
- NOTICE File
- Modification Notices

These additions make Apache 2.0 more comprehensive than MIT or BSD while remaining a permissive license.

---

# History

The Apache Software Foundation manages hundreds of open-source projects used across the world.

As these projects grew, the foundation needed a license that:

- Encouraged widespread adoption.
- Allowed commercial use.
- Protected contributors from patent disputes.
- Reduced legal uncertainty for companies.

This led to the release of **Apache License 2.0** in 2004.

Today, it is one of the most widely used licenses for enterprise open-source projects.

---

# Philosophy

Apache License 2.0 follows the same core philosophy as MIT:

> "Make software easy for everyone to use."

But it adds another principle:

> "Protect contributors and users from unnecessary patent disputes."

This is why many large organizations prefer Apache over MIT.

---

# Permissions

Apache License 2.0 grants broad permissions.

You may:

✅ Use the software

✅ Copy the software

✅ Modify the software

✅ Merge it with other software

✅ Redistribute it

✅ Sell commercial products

✅ Use it in proprietary software

✅ Build SaaS applications

In terms of day-to-day development, Apache feels almost identical to MIT.

The difference lies in the additional legal protections.

---

# Obligations

When redistributing Apache-licensed software, you generally need to:

- Preserve the copyright notice.
- Include a copy of the Apache License 2.0.
- Preserve any applicable NOTICE file.
- Clearly indicate significant modifications you made.

Unlike GPL, Apache **does not** require you to release your own application's source code.

---

# Patent Grant

This is the feature that makes Apache License 2.0 unique.

## What is a Patent?

Copyright protects **software code**.

A patent protects an **invention or technical method**.

Example:

Imagine a company invents a new machine-learning algorithm.

The source code is protected by copyright.

The algorithm itself may also be protected by patents.

These are different forms of intellectual property.

---

## The Problem

Suppose a company contributes code to an open-source project.

Later, the same company claims:

> "You're using our patented technology."

Without an explicit patent license, users could face legal uncertainty.

---

## Apache's Solution

Apache License 2.0 includes an **explicit patent grant**.

By contributing code to an Apache-licensed project, contributors also grant users permission to use any patents that are necessarily infringed by their contribution.

This provides additional confidence to organizations adopting the software.

> **Important:** The patent grant is not unlimited. It applies to patents that are necessarily practiced by the contributor's contribution under the terms of the license.

---

# Patent Termination Clause

Apache also includes a patent termination provision.

If someone files a patent lawsuit alleging that the Apache-licensed software infringes their patent, the patent license granted to that party under Apache 2.0 may terminate.

The idea is to discourage contributors or users from benefiting from the patent grant while simultaneously pursuing certain patent infringement claims related to the licensed work.

This clause helps reduce patent-related conflicts within the project ecosystem.

---

# NOTICE File

Apache introduces another concept not found in MIT.

Many Apache projects include a file named:

```
NOTICE
```

The NOTICE file may contain:

- Copyright information
- Attribution
- Trademark acknowledgements
- Additional notices from contributors

If a NOTICE file is included in the project, you generally need to preserve its required contents when redistributing the software.

This helps ensure that important attribution and legal information remains available.

---

# Modification Notices

Apache also expects distributors of modified versions to indicate that changes have been made.

For example:

```
Modified by Vibhav Khaneja
July 2026
Added authentication module
```

You do **not** need to describe every line of code you changed.

The goal is simply to avoid confusion between the original project and your modified version.

---

# Commercial Use

Apache License 2.0 is fully commercial-friendly.

A company may:

```
Apache Project

↓

Modify

↓

Combine with Proprietary Code

↓

Sell Product

↓

Keep Proprietary Code Closed
```

This is completely allowed, provided the Apache license obligations are met.

Apache is therefore widely used by companies building commercial products.

---

# Advantages

Apache License 2.0 offers:

- Broad software freedoms.
- Commercial friendliness.
- Explicit patent protection.
- Enterprise legal clarity.
- Compatibility with many software ecosystems.
- Strong community trust.

For organizations concerned about patents, Apache often provides more reassurance than MIT or BSD.

---

# Limitations

Apache License 2.0 is still permissive.

This means:

- Companies can keep improvements private.
- Proprietary products are allowed.
- Source code disclosure is not required.
- Community contributions remain voluntary.

Authors who want to ensure modifications remain open source typically choose a copyleft license instead.

---

# Apache vs MIT

At first glance, Apache and MIT seem almost identical.

Both allow:

- Commercial use
- Modification
- Redistribution
- Proprietary software

The major differences are:

| Feature | MIT | Apache 2.0 |
|----------|-----|-------------|
| Commercial Use | ✅ | ✅ |
| Proprietary Software | ✅ | ✅ |
| Copyright Notice | ✅ | ✅ |
| License Text | ✅ | ✅ |
| Explicit Patent Grant | ❌ | ✅ |
| Patent Termination Clause | ❌ | ✅ |
| NOTICE File | ❌ | ✅ (when applicable) |
| Modification Notices | ❌ | ✅ |

For an individual developer building a small library, MIT is often sufficient.

For a large organization collaborating on complex software, Apache's additional protections can be valuable.

---

# Real-World Projects

Many major open-source projects use Apache License 2.0, including:

- Kubernetes
- Prometheus
- Apache Kafka
- Apache Spark
- Apache Hadoop
- Apache Airflow
- Helm
- TensorFlow
- OpenTelemetry
- gRPC

These projects involve contributions from many individuals and organizations, making Apache's patent and notice provisions especially useful.

---

# When Should You Choose Apache License 2.0?

Apache 2.0 is a strong choice when you want:

- Broad commercial adoption.
- Enterprise-friendly licensing.
- Explicit patent protection.
- Contributions from many organizations.
- A permissive license with additional legal safeguards.

It is particularly well suited for:

- Cloud-native projects
- Infrastructure tools
- AI and machine learning frameworks
- Enterprise SDKs
- Large collaborative open-source projects

---

# Summary

Apache License 2.0 is a permissive license that combines the flexibility of MIT with additional legal protections.

Like MIT, it allows users to:

- Use software freely
- Modify it
- Redistribute it
- Build proprietary commercial products

Unlike MIT, it also provides:

- An explicit patent grant
- A patent termination clause
- NOTICE file requirements (when applicable)
- Modification notices

These additions have made Apache License 2.0 one of the most trusted licenses for enterprise open-source software.

For this reason, many of today's most influential cloud-native and infrastructure projects—including Kubernetes, Prometheus, TensorFlow, and Apache Kafka—use Apache License 2.0.

# 5. LGPL (GNU Lesser General Public License)

## Overview

LGPL is a **weak copyleft** license created by the Free Software Foundation.

It was designed mainly for **software libraries**.

The idea is simple:

> "Protect improvements made to the library itself, but don't force every application using the library to become open source."

Because of this, LGPL is considered a compromise between MIT and GPL.

---

## Philosophy

Unlike MIT, LGPL wants improvements to the **library** to remain open.

Unlike GPL, it does **not** usually require the entire application using the library to be released under LGPL.

This makes LGPL popular for reusable libraries.

---

## Permissions

Users may:

- Use the library
- Modify the library
- Redistribute it
- Use it commercially
- Link it with proprietary software (subject to LGPL requirements)

---

## Obligations

If you modify the LGPL library and distribute it:

- You must make those modifications to the LGPL-covered library available under LGPL.

Your own independent application can often remain proprietary.

---

## Typical Use Case

```
Proprietary Application

↓

Uses LGPL Library

↓

Application stays closed

↓

Changes to LGPL Library

↓

Must be shared under LGPL if distributed
```

---

## Real-World Examples

- FFmpeg (parts)
- GTK
- glibc

---

## When to Choose LGPL

Choose LGPL if you are creating:

- Reusable libraries
- SDKs
- Framework components

and you want companies to adopt them without requiring the entire application to become open source.

---

# 6. MPL 2.0 (Mozilla Public License)

## Overview

MPL 2.0 is another **weak copyleft** license.

Unlike LGPL, MPL protects **individual source files**, not the entire project.

This is called **file-level copyleft**.

---

## Philosophy

MPL says:

> "If you modify an MPL-licensed file and distribute it, you must publish that modified file."

However, new files that you write yourself can remain under a different license.

This makes MPL more flexible than GPL while still encouraging contributions.

---

## Permissions

- Commercial use
- Modification
- Redistribution
- Proprietary software alongside MPL files

---

## Obligations

If you modify an existing MPL file:

- That modified file must remain under MPL when distributed.

Files you create independently may use another license.

---

## Typical Example

```
Project

│

├── fileA.cpp (MPL)

├── fileB.cpp (MPL)

└── myNewModule.cpp (Proprietary)
```

Only the modified MPL-covered files need to remain MPL.

---

## Real-World Examples

- Firefox
- Thunderbird
- OpenTofu

---

## When to Choose MPL

Choose MPL when you want:

- Contributions back to modified files
- Commercial adoption
- Easier integration than GPL

---

# LGPL vs MPL

| Feature | LGPL | MPL |
|----------|------|------|
| Protects | Library | Individual Files |
| Proprietary Applications | Usually Allowed | Allowed |
| Source Sharing | Modified Library | Modified MPL Files |
| Copyleft Strength | Weak | Weak |

---

# 7. GPL (GNU General Public License)

## Overview

GPL is the world's best-known **strong copyleft** license.

Its purpose is not to restrict commercial use.

Its purpose is to ensure that **software freedoms continue for future users whenever the license's conditions are triggered (typically by distribution of derivative works).**

---

## Philosophy

GPL believes:

> "If you distribute software built from GPL-covered code, recipients should receive the same freedoms you received."

This prevents companies from taking GPL-covered code, modifying it, and distributing the modified version as closed-source software.

---

## Permissions

GPL allows:

- Commercial use
- Selling software
- Modification
- Redistribution
- Private/internal use

---

## Obligations

When you distribute a derivative work covered by GPL:

- The corresponding GPL-covered source code must be made available.
- GPL license terms must be preserved.

This is called **strong copyleft**.

---

## GPL v2 vs GPL v3

### GPL v2

- Older version
- Used by Linux Kernel
- Simpler

### GPL v3

Adds protections such as:

- Better patent provisions
- Protection against "Tivoization" (devices preventing users from running modified versions of GPL software)
- Improved compatibility with modern software ecosystems

---

## Real-World Examples

- Linux Kernel (GPL v2)
- Git (GPL v2)
- GNU Compiler Collection (GCC)

---

## When to Choose GPL

Choose GPL when you want:

- Every distributed improvement to remain open source
- Strong community collaboration
- Strong protection against proprietary redistribution of covered code

---

# 8. AGPL (GNU Affero General Public License)

## Overview

AGPL extends GPL for cloud computing and SaaS.

It was created because companies could modify GPL software and run it as an online service without distributing copies, meaning GPL's distribution-triggered obligations might not apply.

---

## Philosophy

AGPL says:

> "Users interacting with modified software over a network should also have access to the corresponding source code."

This closes what is often called the "SaaS loophole."

---

## Why AGPL Exists

Traditional GPL:

```
Modify

↓

Run on Server

↓

No Distribution

↓

GPL source-sharing obligations may not apply
```

AGPL:

```
Modify

↓

Run on Server

↓

Users interact over network

↓

AGPL can require offering the corresponding source code
```

---

## Real-World Examples

- Grafana OSS
- Mattermost (community editions have used AGPL)
- Some MongoDB components historically used AGPL before later licensing changes

---

## When to Choose AGPL

Choose AGPL when you want:

- SaaS improvements to remain available
- Hosted modifications shared under the license terms
- Strongest copyleft protection for network services

---

# Quick Comparison

| License | Type | Commercial Use | Proprietary Apps | Main Requirement |
|----------|------|---------------|------------------|------------------|
| MIT | Permissive | ✅ | ✅ | Keep copyright and license |
| BSD | Permissive | ✅ | ✅ | MIT + optional non-endorsement |
| Apache 2.0 | Permissive | ✅ | ✅ | Patent grant + NOTICE (when applicable) |
| LGPL | Weak Copyleft | ✅ | Usually Yes | Share modifications to LGPL library |
| MPL 2.0 | Weak Copyleft | ✅ | Yes | Share modified MPL files |
| GPL | Strong Copyleft | ✅ | Limited by GPL obligations | Share corresponding source for distributed GPL-covered derivative works |
| AGPL | Strong Copyleft | ✅ | Limited by AGPL obligations | GPL obligations plus certain network-use requirements |

---

# Remember These Seven Lines

- **MIT** → "Use it however you want; keep my copyright and license."
- **BSD** → "Like MIT, plus a non-endorsement clause in the 3-Clause version."
- **Apache 2.0** → "Like MIT, plus patent protection and NOTICE requirements."
- **LGPL** → "Protect the library, not necessarily the whole application."
- **MPL 2.0** → "Protect modified files, not the whole project."
- **GPL** → "If you distribute GPL-covered derivative works, keep those freedoms available."
- **AGPL** → "GPL, extended so certain network users can also receive the corresponding source code."

# 9. Choosing the Right License

Choosing an open-source license depends on **your goals as the software author**. There is no universally "best" license.

Ask yourself:

- Do I want maximum adoption?
- Do I want companies to use my software freely?
- Do I want improvements to remain open source?
- Am I building a library or a complete application?
- Will my software mainly be used as a SaaS platform?

The answers guide your license choice.

---

## If You Want Maximum Adoption

Choose:

- MIT
- BSD
- Apache 2.0

Why?

- Easy to understand
- Commercial-friendly
- Compatible with proprietary software
- Encourages widespread use

Best for:

- JavaScript libraries
- Python packages
- SDKs
- Developer tools
- APIs
- Utility libraries

---

## If You Want Patent Protection

Choose:

**Apache License 2.0**

Why?

- Explicit patent grant
- Patent termination clause
- Trusted by enterprises
- Encourages contributions from companies

Best for:

- Enterprise frameworks
- Cloud-native tools
- AI/ML platforms
- Infrastructure software

---

## If You Are Building a Library

If you want anyone to use your library freely:

Choose:

- MIT
- BSD
- Apache

If you want improvements to the **library itself** to remain open:

Choose:

- LGPL

---

## If You Want File-Level Protection

Choose:

**MPL 2.0**

Why?

- Only modified MPL files must remain open.
- New files can remain proprietary.
- Easier to adopt than GPL.

---

## If You Want Every Distributed Improvement to Stay Open

Choose:

**GPL**

GPL is suitable when your primary goal is preserving software freedom.

It ensures that recipients of distributed GPL-covered derivative works receive the same freedoms that you originally provided.

---

## If You Are Building a SaaS Platform

Choose:

**AGPL**

Why?

Traditional GPL focuses on software distribution.

AGPL also addresses software offered over a network, helping ensure that certain modifications made to hosted services are shared under the license.

---

## License Recommendations by Project Type

| Project Type | Recommended License |
|--------------|--------------------|
| Personal Project | MIT |
| Small Utility | MIT |
| JavaScript Library | MIT |
| Python Package | MIT |
| Enterprise SDK | Apache 2.0 |
| Cloud Platform | Apache 2.0 |
| Kubernetes Operator | Apache 2.0 |
| Infrastructure Tool | Apache 2.0 |
| Reusable Library | LGPL |
| Browser Framework | MPL 2.0 |
| Desktop Application | MIT / Apache |
| Operating System | GPL |
| SaaS Platform | AGPL |

---

# Real-World Examples

| Project | License | Why This License? |
|---------|---------|-------------------|
| React | MIT | Encourage maximum adoption |
| Next.js | MIT | Commercial-friendly |
| Express | MIT | Simple and permissive |
| Vite | MIT | Easy ecosystem integration |
| Tailwind CSS | MIT | Broad community adoption |
| Kubernetes | Apache 2.0 | Enterprise use + patent protection |
| Prometheus | Apache 2.0 | CNCF collaboration |
| Helm | Apache 2.0 | Cloud-native ecosystem |
| TensorFlow | Apache 2.0 | Enterprise-friendly AI framework |
| Apache Kafka | Apache 2.0 | Large-scale distributed systems |
| OpenTelemetry | Apache 2.0 | Contributions from many organizations |
| Linux Kernel | GPL v2 | Preserve distributed kernel modifications |
| Git | GPL v2 | Strong copyleft philosophy |
| OpenTofu | MPL 2.0 | File-level copyleft with commercial flexibility |
| Firefox | MPL 2.0 | Balance openness and flexibility |
| GTK | LGPL | Library intended for broad use |
| Grafana OSS | AGPL | Encourage sharing of hosted modifications |

---

# Which License Should You Choose?

```
Do you want maximum adoption?
        │
       Yes
        │
        ▼
 MIT / BSD / Apache
        │
        │
Need explicit patent protection?
        │
       Yes
        │
        ▼
 Apache 2.0
        │
        │
Want improvements to stay open?
        │
       Yes
        │
        ▼
 Is it mainly a library?
        │
      Yes        No
       │          │
       ▼          ▼
     LGPL       GPL
                   │
                   │
Software mainly offered over a network?
                   │
                  Yes
                   │
                   ▼
                 AGPL
```

---

# Key Recommendation

For most developers:

- **MIT** is an excellent default for small libraries and personal projects.
- **Apache 2.0** is often preferred for enterprise or collaborative infrastructure projects.
- **LGPL** is suitable for reusable libraries where you want improvements to the library itself shared.
- **MPL 2.0** offers a balanced, file-level copyleft approach.
- **GPL** is appropriate when preserving software freedoms for distributed derivative works is your highest priority.
- **AGPL** is designed for software delivered as a network service.

---

# 10. License Compatibility

## What is License Compatibility?

License compatibility answers a practical question:

> **Can software under one license be combined with software under another license while complying with both licenses?**

When combining code from different projects, you must satisfy the obligations of all applicable licenses.

Some licenses work together easily.

Others have conditions or are incompatible.

---

## MIT Compatibility

MIT is highly compatible.

It can usually be combined with:

- MIT
- BSD
- Apache 2.0
- LGPL
- MPL
- GPL (the resulting combined work must satisfy GPL where applicable)

MIT's simplicity makes it one of the easiest licenses to reuse.

---

## BSD Compatibility

BSD is also highly compatible.

It generally works well with:

- MIT
- Apache
- GPL
- LGPL
- MPL

The BSD 3-Clause non-endorsement clause usually does not create practical compatibility issues.

---

## Apache 2.0 Compatibility

Apache works well with:

- MIT
- BSD
- LGPL
- MPL

Apache 2.0 is **compatible with GPLv3**, but **not with GPLv2-only** due to differences in license terms, including patent provisions.

This is one of the most commonly discussed compatibility points.

---

## LGPL Compatibility

LGPL was specifically designed so that many proprietary applications can use LGPL libraries while complying with LGPL's requirements.

If you modify the LGPL-covered library itself and distribute those modifications, you generally need to make those library modifications available under LGPL.

---

## MPL Compatibility

MPL is relatively flexible.

Only the MPL-covered files remain under MPL.

Other files in the same project may use different licenses.

This makes MPL easier to combine with proprietary code than GPL in many cases.

---

## GPL Compatibility

GPL is more restrictive because it seeks to preserve software freedoms.

When GPL obligations apply to a distributed derivative work, the combined work must comply with GPL requirements.

This is why organizations carefully evaluate whether GPL code is appropriate for a project.

---

## AGPL Compatibility

AGPL follows GPL principles but extends certain obligations to software provided over a network.

Organizations building SaaS products often review AGPL carefully because of these additional requirements.

---

# Compatibility Matrix

| License | Can Be Used in Proprietary Software? | Compatible with MIT | Compatible with Apache 2.0 | Compatible with GPLv3 |
|----------|--------------------------------------|---------------------|-----------------------------|-----------------------|
| MIT | ✅ | ✅ | ✅ | ✅ (under GPL terms for the combined work) |
| BSD | ✅ | ✅ | ✅ | ✅ |
| Apache 2.0 | ✅ | ✅ | ✅ | ✅ |
| LGPL | Usually Yes | ✅ | ✅ | ✅ |
| MPL 2.0 | Yes | ✅ | ✅ | Limited, depends on how code is combined |
| GPL | Limited by GPL obligations | MIT code can be included under GPL terms | Apache 2.0 (GPLv3) | ✅ |
| AGPL | Limited by AGPL obligations | MIT code can be included under AGPL terms | Apache 2.0 (subject to AGPL compliance) | ✅ |

> **Note:** License compatibility can become legally complex depending on how software is combined (copying code, static linking, dynamic linking, plugins, separate processes, etc.). The table above provides a practical, high-level overview rather than legal advice.

---

# Enterprise Compliance

Large organizations rarely check licenses manually.

Instead, they use automated Software Composition Analysis (SCA) tools to identify dependencies and their licenses.

Common tools include:

- GitHub Dependency Graph
- GitHub License Detection
- Snyk
- FOSSA
- Black Duck
- Mend (formerly WhiteSource)
- Sonatype Nexus Lifecycle

These tools help organizations:

- Detect licenses
- Identify license conflicts
- Generate Software Bills of Materials (SBOMs)
- Monitor compliance risks

---

# Final Cheat Sheet

| License | Type | Commercial Use | Share Source? | Best For |
|----------|------|---------------|---------------|----------|
| MIT | Permissive | ✅ | No | Libraries, tools, personal projects |
| BSD | Permissive | ✅ | No | Operating systems, networking software |
| Apache 2.0 | Permissive | ✅ | No | Enterprise, cloud, CNCF, AI |
| LGPL | Weak Copyleft | ✅ | Modified library (when distributed) | Reusable libraries |
| MPL 2.0 | Weak Copyleft | ✅ | Modified MPL files (when distributed) | Frameworks, browsers |
| GPL | Strong Copyleft | ✅ | Distributed GPL-covered derivative works | Community-driven applications |
| AGPL | Strong Copyleft | ✅ | Distributed derivative works and certain network deployments | SaaS, hosted platforms |

---

# Final Thoughts

You do not need to memorize every clause of every license.

Instead, remember the philosophy behind each one:

- **MIT** → "Use it freely."
- **BSD** → "MIT with a historical variant and an optional non-endorsement clause."
- **Apache 2.0** → "MIT plus enterprise patent protection."
- **LGPL** → "Protect the library."
- **MPL 2.0** → "Protect the modified files."
- **GPL** → "Protect software freedom for distributed derivative works."
- **AGPL** → "Extend GPL principles to software used over a network."

Understanding these philosophies will help you evaluate almost any open-source project you encounter in software engineering, DevOps, cloud computing, AI, or enterprise development.