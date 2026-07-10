# Software Licensing Fundamentals
## Part 1 – Foundations

> "Every piece of software is protected by copyright. A software license determines how others may legally use, modify, and distribute that software."

---

# Table of Contents

1. Introduction
2. Why Software Licensing Exists
3. What is a Software License?
4. Why Software Licenses Matter
5. Copyright vs License
6. Types of Software
7. Proprietary Software
8. Open Source Software
9. Source Available Software
10. Key Takeaways

---

# 1. Introduction

Almost every software application developed today relies on open-source software.

A simple web application may use:

- React
- Node.js
- Express
- PostgreSQL
- Docker
- Kubernetes
- Prometheus

An AI application may additionally use:

- TensorFlow
- PyTorch
- Hugging Face libraries
- NumPy
- Pandas

Each of these projects is governed by a software license.

These licenses determine:

- Whether the software may be used commercially.
- Whether the source code may be modified.
- Whether the software may be redistributed.
- Whether modified versions must also be open source.
- Whether proprietary applications can use the software.

Because organizations often depend on hundreds or even thousands of third-party packages, understanding software licensing is not just a legal concern—it is also an engineering and compliance responsibility.

This handbook builds a foundation before studying individual licenses such as MIT, Apache 2.0, BSD, GPL, LGPL, MPL, and AGPL.

---

# 2. Why Software Licensing Exists

To understand software licenses, we first need to understand software ownership.

Suppose Alice writes a Python library.

```python
def add(a, b):
    return a + b
```

Although the code is only a few lines long, Alice automatically owns the copyright to that code.

This means that nobody else may legally:

- Copy the code
- Modify the code
- Publish the code
- Redistribute the code

unless Alice grants permission.

That permission is granted through a software license.

Without a license, software is **not automatically free to use**, even if it is publicly visible.

This is one of the biggest misconceptions in software development.

Many beginners assume:

> "If it is on GitHub, I can use it."

This is incorrect.

Public visibility does **not** equal permission.

The license is what grants legal rights.

---

# 3. What is a Software License?

A software license is a legal agreement that defines how software may be used.

It specifies:

- Who may use the software.
- What modifications are allowed.
- Whether redistribution is allowed.
- Whether commercial use is permitted.
- What obligations users must follow.

Think of the license as a rulebook created by the copyright owner.

It answers questions such as:

- Can I use this in my company?
- Can I modify the source code?
- Can I sell software built using this project?
- Do I have to publish my own source code?
- Must I keep the original copyright notice?

Different licenses answer these questions differently.

For example:

| License | Can I Modify? | Can I Sell? | Must I Open Source My Application? |
|----------|---------------|-------------|------------------------------------|
| MIT | Yes | Yes | No |
| Apache 2.0 | Yes | Yes | No |
| GPL | Yes | Yes | Yes (when GPL obligations are triggered by distribution of derivative works) |

---

# 4. Why Software Licenses Matter

Software licenses protect both software creators and software users.

## For Software Authors

A license allows the author to:

- Protect intellectual property.
- Encourage community contributions.
- Define acceptable usage.
- Prevent unauthorized distribution.
- Choose how open or restrictive the project should be.

Different authors have different goals.

Some want maximum adoption.

Others want every improvement to remain open source.

The chosen license reflects those goals.

---

## For Users

Software licenses clarify:

- Whether commercial use is permitted.
- Whether modifications are allowed.
- Whether redistribution is permitted.
- What obligations must be followed.
- Whether proprietary software may use the project.

Without a clear license, organizations face unnecessary legal uncertainty.

---

## For Organizations

Modern software products often contain hundreds or thousands of dependencies.

Organizations therefore perform license compliance checks to answer questions like:

- Are we allowed to sell this software?
- Must we disclose our source code?
- Are we violating any license terms?
- Are there patent-related risks?

Many companies use automated license scanners during their software development lifecycle to ensure compliance.

---

# 5. Copyright vs License

These are two of the most commonly confused concepts.

Although related, they are not the same.

---

## What is Copyright?

Copyright represents ownership.

The moment a developer creates original software, copyright automatically belongs to the creator.

The copyright owner has exclusive rights to:

- Copy the software.
- Modify the software.
- Publish the software.
- Distribute the software.
- License the software.

Nobody else has these rights unless permission is granted.

---

## What is a License?

A license is permission granted by the copyright owner.

The owner still owns the software.

The license simply tells others what they are allowed to do.

For example, an MIT license allows users to:

- Use the software.
- Modify it.
- Redistribute it.
- Sell products using it.

A GPL license also allows modification and commercial use, but it imposes additional obligations when distributing derivative works.

---

## Copyright vs License

| Copyright | License |
|------------|----------|
| Represents ownership | Represents permission |
| Automatically belongs to the creator | Created by the copyright owner |
| Protects intellectual property | Defines legal usage rights |
| Cannot be used by others without permission | Grants specific permissions under defined conditions |

A useful analogy is:

- **Copyright** is like owning a house.
- **License** is like giving someone permission to live in, renovate, or rent that house under specific rules.

---

# 6. Types of Software

Software can broadly be classified into three categories.

```
Software
│
├── Proprietary
│
├── Open Source
│
└── Source Available
```

Although "Source Available" is sometimes confused with open source, it is a separate category.

Understanding these three categories is essential before studying software licenses.

---

# 7. Proprietary Software

Proprietary software is software whose source code is **not publicly available**.

Only the copyright owner controls:

- Who may use it.
- Who may modify it.
- Who may distribute it.

Users receive permission only to use the software according to the vendor's End User License Agreement (EULA).

They generally cannot:

- View the source code.
- Modify the source code.
- Redistribute copies.
- Create derivative works.

### Characteristics

- Closed source.
- Commercial ownership.
- Source code unavailable.
- Modification prohibited.
- Redistribution prohibited.

### Examples

- Microsoft Windows
- Microsoft Office
- Adobe Photoshop
- Oracle Database

---

## Advantages

- Vendor retains complete control.
- Intellectual property remains protected.
- Centralized support and updates.
- Consistent user experience.

---

## Limitations

- Limited customization.
- Vendor lock-in.
- No community contributions.
- No transparency into the source code.

---

# 8. Open Source Software

Open-source software makes its source code available under an open-source license.

This allows developers to:

- Read the source code.
- Learn from it.
- Modify it.
- Redistribute it.
- Build upon it according to the license terms.

Open source does **not** mean "free of restrictions."

Every open-source project has a license, and that license defines the rights and obligations of users.

For example:

An MIT-licensed project and a GPL-licensed project are both open source, but they impose different obligations on users.

---

## Characteristics

- Source code available.
- Community collaboration.
- Transparent development.
- Public issue tracking.
- Public code review.
- Governed by an open-source license.

---

## Advantages

- Transparency.
- Faster innovation.
- Community contributions.
- Vendor independence.
- Easier security auditing.
- Lower licensing costs.

---

## Limitations

- Community support may vary.
- Multiple project forks may exist.
- License compliance is still required.
- Organizations remain responsible for legal obligations.

---

## Examples

- Linux
- Kubernetes
- Prometheus
- PostgreSQL
- React
- TensorFlow
- Git

---

# 9. Source Available Software

Source Available software occupies a middle ground between proprietary software and open-source software.

The source code is visible to users.

However, additional restrictions prevent the software from meeting the Open Source Initiative (OSI) definition of open source.

Examples of additional restrictions may include:

- Limits on commercial use.
- Restrictions on providing competing hosted services.
- Delayed conversion to an open-source license.
- Other usage restrictions beyond standard copyright.

Because of these additional conditions, source-available software is **not** considered open source.

---

## Why Do Companies Choose Source Available Licenses?

Some organizations want to:

- Share their source code.
- Encourage community contributions.
- Allow users to inspect the implementation.

while also preventing large cloud providers or competitors from commercially offering the software without meeting specific conditions.

This approach attempts to balance openness with commercial sustainability.

---

## Example

Terraform changed from the MPL 2.0 license to the Business Source License (BUSL) beginning with version 1.6.

BUSL is considered **source available**, not an OSI-approved open-source license.

This licensing change led to the creation of OpenTofu, which continues under the MPL 2.0 open-source license.

---

# Comparison of Software Types

| Feature | Proprietary | Open Source | Source Available |
|----------|------------|-------------|------------------|
| Source Code Visible | ❌ | ✅ | ✅ |
| Modification Allowed | Usually ❌ | Depends on License | Limited by License |
| Redistribution Allowed | Usually ❌ | Depends on License | Limited |
| Commercial Use | Depends on Vendor | Depends on License | Depends on License |
| OSI Approved | ❌ | ✅ | ❌ |

---

# Key Takeaways

- Every software project is protected by copyright from the moment it is created.
- A software license grants legal permission to use copyrighted software.
- Publicly visible code is not automatically open source.
- Proprietary software keeps the source code private and restricts modification and redistribution.
- Open-source software provides access to source code under an approved license, but every license has conditions.
- Source-available software exposes its source code while imposing additional restrictions that prevent it from being classified as open source.
- Understanding these concepts is the foundation for studying permissive and copyleft licenses.

---

## What's Next?

In **Part 2**, we will study the terminology used throughout software licensing, including:

- Source Code
- Binary/Executable
- Copyright Notice
- License Notice
- Redistribution
- Distribution vs Internal Use
- Commercial Use
- Private Use
- Derivative Works
- Attribution
- Patent
- Patent Grant
- NOTICE Files
- Public Domain

Mastering these terms will make individual licenses like MIT, Apache 2.0, BSD, GPL, LGPL, MPL, and AGPL much easier to understand.

# Software Licensing Fundamentals
## Part 2 – Licensing Terminology

> "Every software license uses a common set of legal and technical terms. Understanding these terms is essential before studying individual licenses."

---

# Table of Contents

1. Introduction
2. Source Code
3. Object Code / Binary / Executable
4. Copyright
5. Copyright Notice
6. License Notice
7. Attribution
8. Redistribution
9. Distribution vs Internal Use
10. Commercial Use
11. Private Use
12. Proprietary Software
13. Derivative Works
14. Linking
15. Patent
16. Patent Grant
17. NOTICE File
18. Public Domain
19. Fork
20. Sublicensing
21. Common Misconceptions
22. Summary

---

# 1. Introduction

Software licenses are legal documents.

Like any legal document, they contain specific terminology that has precise meanings.

For example:

- MIT says you may **redistribute** software.
- GPL talks about **derivative works**.
- Apache discusses **patent grants**.
- BSD requires preservation of **copyright notices**.

If these terms are not understood correctly, the license itself becomes difficult to understand.

This chapter explains the terminology that appears repeatedly throughout software licensing.

---

# 2. Source Code

Source code is the human-readable form of software written by developers.

Examples include:

```python
def add(a, b):
    return a + b
```

```javascript
function hello() {
    console.log("Hello World");
}
```

This is the code developers read, write, and modify.

Most software licenses primarily govern the source code.

---

## Why is Source Code Important?

Source code allows developers to:

- Understand how software works.
- Fix bugs.
- Add new features.
- Improve performance.
- Learn implementation details.

Without source code, modification is nearly impossible.

---

# 3. Object Code / Binary / Executable

Computers cannot directly execute source code.

Source code is usually compiled into machine-readable instructions called:

- Object Code
- Binary
- Executable

Example:

```
calculator.py
        ↓
Python Interpreter

or

calculator.c
        ↓
Compiler
        ↓
calculator.exe
```

Users normally install executables.

Developers work with source code.

Some licenses distinguish between distributing source code and distributing binaries.

---

# 4. Copyright

Copyright represents ownership.

Whenever someone creates original software, they automatically become its copyright holder.

No registration is required in most countries.

The copyright owner controls:

- Copying
- Publishing
- Modifying
- Distributing
- Licensing

Copyright exists whether or not software is open source.

---

## Example

Suppose you create:

```
inventory-system.py
```

Immediately:

```
You

↓

Own Copyright

↓

Choose License

↓

Others Receive Permission
```

---

# 5. Copyright Notice

A copyright notice identifies the owner of the software.

Example:

```
Copyright (c) 2026 Vibhav Khaneja
```

or

```
Copyright (c) Microsoft Corporation
```

Many licenses require this notice to remain intact.

Removing it can violate the license.

---

# Why is the Copyright Notice Important?

It tells users:

- Who owns the software.
- Who created it.
- Who grants the license.

It does **not** grant permission by itself.

Permission comes from the license.

---

# 6. License Notice

A license notice tells users which license governs the software.

Example:

```
Licensed under the MIT License.
```

or

```
Licensed under Apache License 2.0.
```

The license notice tells users where to find the complete license terms.

---

# Difference Between Copyright Notice and License Notice

Copyright Notice:

```
Who owns the software?
```

License Notice:

```
What are you allowed to do?
```

---

# 7. Attribution

Attribution means giving proper credit to the original author.

Many open-source licenses require attribution.

Typical attribution includes:

- Original author's name.
- Copyright notice.
- License text.

Example:

```
This software includes code from Project XYZ,
licensed under the MIT License.
```

Attribution does **not** mean advertising someone else's product.

It simply means acknowledging the original creator.

---

# 8. Redistribution

Redistribution is one of the most important concepts in software licensing.

Redistribution means:

> Making software available to another person or organization.

Examples:

- Uploading to GitHub.
- Publishing to npm.
- Uploading to PyPI.
- Shipping software to customers.
- Selling desktop applications.
- Emailing software to another company.

All of these are redistribution.

---

## Examples

```
Developer

↓

Publishes project on GitHub

↓

Redistribution
```

```
Company

↓

Ships software to customers

↓

Redistribution
```

---

## Why Redistribution Matters

Many licenses only impose obligations **when redistribution occurs.**

For example:

GPL requires source code sharing when distributing derivative works.

If software is never distributed, those obligations may not apply.

---

# 9. Distribution vs Internal Use

These two concepts are often confused.

---

## Distribution

Giving software to another party.

Examples:

- Selling software.
- Publishing software.
- Sharing executables.
- Uploading packages.

---

## Internal Use

Software remains inside your organization.

Example:

```
Company

↓

Downloads GPL Software

↓

Modifies Software

↓

Uses Internally
```

Nothing has been distributed.

Many copyleft obligations are triggered by distribution, not merely internal use.

---

# 10. Commercial Use

Commercial use simply means:

Using software to generate revenue.

Examples:

- Selling applications.
- SaaS platforms.
- Consulting products.
- Enterprise software.
- Paid mobile applications.

Commercial use is permitted by many open-source licenses, including MIT, BSD, Apache, GPL, LGPL, and MPL.

The differences lie in the obligations attached to that use.

---

# 11. Private Use

Private use means using software without distributing it.

Examples:

- Personal projects.
- Internal company tools.
- Research.
- Development environments.

Private use usually has fewer obligations because redistribution has not occurred.

---

# 12. Proprietary Software

Proprietary software keeps its source code private.

Customers receive permission to use the software but cannot access or modify the source code.

Examples:

- Microsoft Windows
- Adobe Photoshop
- Microsoft Office

Some open-source licenses (such as MIT and Apache 2.0) allow proprietary software to include their code.

Others (such as GPL) impose conditions when distributing derivative works.

---

# 13. Derivative Works

A derivative work is software created by modifying or building upon an existing project.

Examples include:

- Adding new features.
- Fixing bugs.
- Changing functionality.
- Translating source code.
- Combining code into another project.

Example:

```
Original Project

↓

Modify Source Code

↓

New Version

↓

Derivative Work
```

Derivative works are central to copyleft licenses because redistribution obligations often apply to them.

---

# 14. Linking

Many applications use libraries instead of copying their source code.

This is called linking.

Two common types are:

## Static Linking

Library code becomes part of the final executable.

```
Application

+

Library

↓

Single Executable
```

---

## Dynamic Linking

The application loads the library at runtime.

```
Application

↓

Loads Library

↓

Runs
```

Linking is especially important for licenses like LGPL, which treat certain forms of linking differently.

---

# 15. Patent

Copyright protects software code.

A patent protects an invention or technical method.

Example:

Suppose a company invents a new compression algorithm.

The implementation is protected by copyright.

The invention itself may also be protected by patents.

These are separate legal rights.

---

# 16. Patent Grant

A patent grant is permission to use patents owned by contributors.

Apache License 2.0 includes an explicit patent grant.

MIT and BSD do not.

This is one reason why large enterprises often prefer Apache 2.0 for collaborative projects.

---

# 17. NOTICE File

Some projects include a NOTICE file.

The NOTICE file may contain:

- Copyright information.
- Attribution.
- Additional acknowledgements.

Apache License 2.0 requires preservation of NOTICE information when applicable.

MIT does not require a NOTICE file.

---

# 18. Public Domain

Public Domain means the copyright owner has effectively waived exclusive rights (where legally possible), allowing anyone to use the work without copyright restrictions.

Public Domain is **not** the same as MIT.

MIT is still protected by copyright.

The author simply grants broad permissions.

---

# 19. Fork

A fork is a copy of an existing project that begins independent development.

Example:

```
Original Project

↓

Fork

↓

Independent Development
```

Forking is common in open-source communities.

The fork must still comply with the original license.

---

# 20. Sublicensing

Sublicensing means granting another license to software you received under an existing license.

Some licenses allow broad sublicensing.

Others require preserving the original license.

The rules vary depending on the license.

---

# 21. Common Misconceptions

### "GitHub means Open Source."

❌ Incorrect.

Code on GitHub without a license is **not automatically open source**.

---

### "Open Source means Free."

❌ Incorrect.

Open source refers to software freedoms, not necessarily price.

Many companies sell services and support around open-source software.

---

### "GPL does not allow commercial use."

❌ Incorrect.

GPL allows commercial use.

It simply imposes obligations when distributing derivative works.

---

### "MIT has no rules."

❌ Incorrect.

MIT requires preservation of copyright and license notices.

---

### "Apache is not permissive."

❌ Incorrect.

Apache 2.0 is a permissive license.

It simply includes additional patent and notice provisions.

---

# 22. Summary

Understanding these terms is essential before studying individual software licenses.

The most important concepts introduced in this chapter are:

- Source Code
- Binary / Executable
- Copyright
- Copyright Notice
- License Notice
- Attribution
- Redistribution
- Distribution vs Internal Use
- Commercial Use
- Private Use
- Proprietary Software
- Derivative Works
- Linking
- Patent
- Patent Grant
- NOTICE File
- Public Domain
- Fork
- Sublicensing

These concepts appear repeatedly in MIT, BSD, Apache 2.0, LGPL, MPL, GPL, and AGPL licenses.

A clear understanding of this terminology makes interpreting individual license requirements significantly easier.

# Software Licensing Fundamentals
## Part 3 – Open Source License Categories

> "Open-source software is not governed by a single license. Different projects have different goals, and those goals are reflected in the license they choose."

---

# Table of Contents

1. Introduction
2. Why Different Open Source Licenses Exist
3. Categories of Open Source Licenses
4. Permissive Licenses
5. Philosophy of Permissive Licensing
6. Rights Granted by Permissive Licenses
7. Obligations of Permissive Licenses
8. Advantages of Permissive Licenses
9. Limitations of Permissive Licenses
10. Why Companies Prefer Permissive Licenses
11. Common Misconceptions
12. Major Permissive Licenses
13. Comparison of Permissive Licenses
14. Summary

---

# 1. Introduction

One of the biggest misconceptions about open-source software is that it is governed by a single "Open Source License."

This is not true.

Instead, open-source software is released under many different licenses, each created with a different philosophy and purpose.

For example:

- Some developers want their software to be used by as many people as possible.
- Others want every improvement made by users to remain open source.
- Some projects prioritize legal simplicity.
- Others prioritize patent protection.

Because different creators have different goals, multiple open-source licenses exist.

Understanding these philosophies is much more valuable than memorizing legal clauses.

---

# 2. Why Different Open Source Licenses Exist

Imagine three developers who each create a useful logging library.

Although they built similar software, they have different goals.

## Developer A

Wants maximum adoption.

"I don't care how people use it.

I only want credit."

This developer is likely to choose a **permissive license**.

---

## Developer B

Wants improvements to remain available to everyone.

"If someone improves my library and distributes it, those improvements should also be shared."

This developer may choose a **copyleft license**.

---

## Developer C

Works for a large technology company.

They want broad adoption but also protection against patent disputes.

This developer may choose **Apache License 2.0**.

---

Each license reflects the author's priorities.

There is no universally "best" license.

The right license depends on the goals of the project.

---

# 3. Categories of Open Source Licenses

Open-source licenses are commonly divided into three categories.

```
Open Source Licenses

│

├── Permissive

├── Weak Copyleft

└── Strong Copyleft
```

Each category balances software freedom and obligations differently.

---

# 4. Permissive Licenses

Permissive licenses grant users broad freedoms with relatively few obligations.

Their philosophy is simple:

> "Take my software and build amazing things with it. Just preserve the required notices."

Permissive licenses encourage adoption by minimizing restrictions.

Most modern startups and many infrastructure projects favor permissive licenses because they simplify commercial use and integration.

---

## Common Permissive Licenses

- MIT License
- BSD 2-Clause License
- BSD 3-Clause License
- Apache License 2.0
- ISC License
- PostgreSQL License

Among these, MIT, BSD, and Apache 2.0 are by far the most common in modern software development.

---

# 5. Philosophy of Permissive Licensing

The primary objective of permissive licensing is **maximum adoption**.

Project authors generally want:

- Developers to use the software.
- Companies to integrate it into products.
- Community contributions.
- Wide industry adoption.
- Minimal legal barriers.

Rather than controlling downstream users, permissive licenses prioritize making software easy to use.

Think of it as the author saying:

> "Use my work however you like. I only ask that you acknowledge where it came from."

---

# 6. Rights Granted by Permissive Licenses

Although individual licenses differ slightly, permissive licenses generally allow users to:

- Use the software.
- Copy the software.
- Study the source code.
- Modify the source code.
- Merge it with other software.
- Publish modified versions.
- Redistribute copies.
- Use the software commercially.
- Build proprietary (closed-source) applications.

These broad permissions are the defining characteristic of permissive licensing.

---

## Example

```
MIT Library

↓

Modify

↓

Combine with Proprietary Application

↓

Sell Application

↓

Keep Source Code Private
```

This workflow is generally allowed under permissive licenses, provided the license conditions are met.

---

# 7. Obligations of Permissive Licenses

Although permissive licenses are flexible, they are not "no rules" licenses.

Common obligations include:

- Preserve the original copyright notice.
- Preserve the license text or required notices.
- Do not falsely claim authorship.

Apache License 2.0 adds additional obligations such as preserving NOTICE information (when applicable) and indicating significant modifications.

Compared with copyleft licenses, these obligations are relatively small.

---

# 8. Advantages of Permissive Licenses

Permissive licenses have become extremely popular because they encourage widespread adoption.

Advantages include:

### Commercial Friendly

Organizations can build commercial products without being required to release their proprietary source code.

---

### Easy Integration

Permissive libraries can usually be integrated into both open-source and proprietary software with minimal legal complexity.

---

### Encourages Adoption

Developers are more likely to use software that imposes few restrictions.

---

### Startup Friendly

Startups can quickly build products without extensive licensing concerns.

---

### Enterprise Friendly

Large organizations often prefer permissive licenses because compliance is relatively straightforward.

---

### Community Growth

Lower barriers encourage broader adoption and contributions.

---

# 9. Limitations of Permissive Licenses

Permissive licensing also has trade-offs.

### Improvements May Never Return

A company may improve the software internally and never contribute those improvements back to the community.

---

### Proprietary Forks

Organizations can create proprietary versions of permissively licensed software.

The original community may never receive those enhancements.

---

### No Guaranteed Community Contributions

Contributions remain voluntary.

Unlike copyleft licenses, there is generally no obligation to publish improvements.

---

### Patent Protection

Only some permissive licenses include explicit patent grants.

Apache 2.0 includes one.

MIT and BSD do not.

---

# 10. Why Companies Prefer Permissive Licenses

Many commercial organizations prefer permissive licenses because they allow:

- Proprietary software development.
- Commercial products.
- Internal modifications.
- Easier legal compliance.
- Lower licensing risk.

This is one reason why many modern cloud-native projects use Apache 2.0 or MIT.

---

## Common Commercial Use Cases

Companies often use permissive licenses for:

- SaaS platforms
- Enterprise software
- Mobile applications
- Internal tools
- Developer SDKs
- APIs
- Web frameworks

---

# 11. Common Misconceptions

## "Permissive means Public Domain."

❌ Incorrect.

Permissive software is still protected by copyright.

The author simply grants broad permissions.

---

## "Permissive licenses have no obligations."

❌ Incorrect.

Users must still comply with the license.

Typical obligations include preserving copyright and license notices.

---

## "Permissive software cannot be sold."

❌ Incorrect.

Commercial use is generally permitted.

---

## "Permissive licenses require publishing source code."

❌ Incorrect.

Users may usually keep their own source code private.

---

## "Apache License is not permissive."

❌ Incorrect.

Apache 2.0 is a permissive license with additional patent protections and notice requirements.

---

# 12. Major Permissive Licenses

Although many permissive licenses exist, three dominate modern software development.

---

## MIT License

Characteristics:

- Extremely simple
- Short
- Commercial friendly
- Minimal obligations
- No explicit patent grant

Examples:

- React
- Express
- Vite
- Next.js
- Tailwind CSS

---

## BSD License

Characteristics:

- Similar to MIT
- Available in multiple variants
- BSD 3-Clause includes a non-endorsement clause

Examples:

- FreeBSD
- OpenBSD
- NetBSD

---

## Apache License 2.0

Characteristics:

- Commercial friendly
- Explicit patent grant
- Patent termination clause
- NOTICE file support
- Modification notices

Examples:

- Kubernetes
- Prometheus
- Apache Kafka
- Apache Spark
- Helm
- TensorFlow
- OpenTelemetry

---

# 13. Comparison of Major Permissive Licenses

| Feature | MIT | BSD | Apache 2.0 |
|----------|-----|-----|-------------|
| Open Source | ✅ | ✅ | ✅ |
| Commercial Use | ✅ | ✅ | ✅ |
| Modification | ✅ | ✅ | ✅ |
| Redistribution | ✅ | ✅ | ✅ |
| Proprietary Applications | ✅ | ✅ | ✅ |
| Copyright Notice | ✅ | ✅ | ✅ |
| License Text / Required Notices | ✅ | ✅ | ✅ |
| Patent Grant | ❌ | ❌ | ✅ |
| Modification Notice | ❌ | ❌ | ✅ (where applicable) |
| NOTICE File Support | ❌ | ❌ | ✅ |

---

# 14. Summary

Open-source software is not governed by a single license.

Different licenses exist because different software authors have different goals.

Permissive licenses prioritize:

- Simplicity
- Broad adoption
- Commercial friendliness
- Minimal restrictions

They allow users to:

- Use software commercially.
- Modify source code.
- Build proprietary applications.
- Redistribute software.

The primary obligations are preserving copyright and license information, with Apache 2.0 adding patent and notice provisions.

The three most important permissive licenses are:

- MIT License
- BSD License
- Apache License 2.0

These licenses form the foundation of many modern open-source ecosystems.

---

## What's Next?

In **Part 4**, we will study the philosophy of **copyleft licensing**, including:

- Why copyleft was created
- Weak vs Strong Copyleft
- Redistribution
- Derivative Works
- Network Distribution (AGPL motivation)
- Permissive vs Copyleft comparison
- Decision tree for selecting a licensing model

Understanding these concepts will prepare us to study individual licenses such as LGPL, MPL, GPL, and AGPL in the next document.

# Software Licensing Fundamentals
## Part 4 – Copyleft Licensing

> "Permissive licenses maximize freedom for developers. Copyleft licenses aim to preserve those freedoms for every future recipient of the software."

---

# Table of Contents

1. Introduction
2. Why Copyleft Was Created
3. Philosophy of Copyleft
4. Understanding Freedom in Open Source
5. Weak Copyleft
6. Strong Copyleft
7. Redistribution
8. Derivative Works
9. Linking
10. Network Distribution (Why AGPL Exists)
11. Permissive vs Copyleft
12. Choosing Between Permissive and Copyleft
13. Comparison Tables
14. Decision Tree
15. Key Takeaways
16. Transition to Individual Licenses

---

# 1. Introduction

In Part 3, we studied **permissive licensing**.

Permissive licenses are designed to maximize adoption by placing very few restrictions on users.

However, not every software author agrees with this philosophy.

Some developers believe that software freedoms should be preserved not only for today's users but also for future users.

This philosophy gave rise to **copyleft licensing**.

---

# 2. Why Copyleft Was Created

Imagine a developer releases an excellent open-source project.

A large company downloads it, improves it significantly, and sells a commercial version.

Because the original project used a permissive license, the company keeps all improvements private.

The community never benefits from those enhancements.

Some developers believe this is acceptable because it encourages widespread adoption.

Others believe this weakens the open-source ecosystem.

They argue:

> "If you benefit from community software and distribute your improvements, those improvements should also remain available to the community."

This idea is the foundation of copyleft.

---

# 3. Philosophy of Copyleft

Copyleft is based on one central principle:

> **Software freedoms should be preserved when software is redistributed under the conditions defined by the license.**

Unlike permissive licenses, copyleft licenses place additional obligations on distributors of modified software.

These obligations are designed to ensure that recipients continue to receive the same freedoms that the original author intended.

Copyleft does **not** prohibit:

- Commercial use
- Selling software
- Modifying software
- Using software internally

Instead, it focuses on **what happens when software is distributed to others.**

---

# 4. Understanding Freedom in Open Source

The term "freedom" in open source refers to user freedoms, not price.

Typical software freedoms include:

- Freedom to use the software.
- Freedom to study the source code.
- Freedom to modify the software.
- Freedom to redistribute copies.
- Freedom to distribute modified versions.

Copyleft licenses attempt to ensure these freedoms remain available for downstream users.

---

# 5. Weak Copyleft

Weak copyleft licenses protect the licensed component itself while allowing larger applications to remain under different licenses.

In simple terms:

> If you modify the open-source component, you generally need to share those modifications when distributing them.

However, your own independent application may often remain proprietary.

Examples include:

- LGPL
- MPL 2.0

---

## Typical Use Case

```
Application (Proprietary)

↓

Uses LGPL Library

↓

Application remains proprietary

↓

Changes to the LGPL library itself
must follow LGPL requirements when distributed
```

Weak copyleft tries to balance:

- Community protection
- Commercial adoption

---

# 6. Strong Copyleft

Strong copyleft licenses go further.

They require that distributed derivative works comply with the copyleft license's requirements.

The exact scope depends on the specific license and how the software is combined.

Examples include:

- GPL v2
- GPL v3
- AGPL

The intention is to ensure that software improvements remain available to future users when distribution triggers the license obligations.

---

# 7. Redistribution

Redistribution is the event that activates many copyleft obligations.

Redistribution means providing software to another person or organization.

Examples include:

- Selling software.
- Publishing software online.
- Shipping software to customers.
- Uploading packages.
- Sharing binaries.

Internal company use generally is **not** redistribution.

---

## Example

```
Download GPL Project

↓

Modify Source Code

↓

Use Internally

↓

No Distribution
```

In many cases, GPL source-sharing obligations are not triggered because the modified software has not been distributed.

Now consider:

```
Download GPL Project

↓

Modify

↓

Sell Product

↓

Distribute Software
```

Now the license obligations associated with distribution become relevant.

---

# 8. Derivative Works

A derivative work is software based on an existing project.

Examples include:

- Bug fixes
- New features
- Performance improvements
- Modified source code
- Adaptations of the original software

Copyleft licenses primarily regulate the distribution of derivative works.

Exactly what constitutes a derivative work can be legally complex and may depend on jurisdiction, so projects often rely on guidance from their license text and community practices.

---

# 9. Linking

Many applications use external libraries.

This is called linking.

Two common forms exist:

## Static Linking

Library code becomes part of the final executable.

```
Application

+

Library

↓

Single Executable
```

---

## Dynamic Linking

The application loads the library at runtime.

```
Application

↓

Shared Library

↓

Program Executes
```

Different licenses treat linking differently.

For example:

- MIT generally imposes no additional obligations based on linking.
- LGPL is specifically designed to allow many forms of proprietary applications to link to LGPL libraries while protecting modifications to the LGPL-covered library itself.
- GPL has stricter requirements that can affect combined works.

The details vary by license and are best studied individually.

---

# 10. Network Distribution – Why AGPL Exists

Traditional GPL focuses on software distribution.

However, modern cloud computing introduced a new situation.

Imagine a company modifies GPL software and runs it only as an online service.

Users interact with the software over the network but never receive a copy.

Since nothing is distributed, many GPL obligations related to distribution may not be triggered.

AGPL was created to address this scenario.

AGPL extends certain source code sharing obligations to users who interact with modified software over a network.

This is why AGPL is often called the "network copyleft" license.

---

# 11. Permissive vs Copyleft

Both approaches support open source, but they prioritize different goals.

## Permissive Philosophy

Goal:

> Encourage maximum adoption with minimal restrictions.

Focus:

- Simplicity
- Commercial use
- Flexibility
- Broad compatibility

Examples:

- MIT
- BSD
- Apache 2.0

---

## Copyleft Philosophy

Goal:

> Preserve software freedoms for future recipients.

Focus:

- Community collaboration
- Sharing improvements (when required by the license)
- Preventing proprietary appropriation of covered code

Examples:

- LGPL
- MPL
- GPL
- AGPL

---

# 12. Choosing Between Permissive and Copyleft

The choice depends on the author's goals.

Choose a **permissive license** if you want:

- Maximum adoption
- Commercial friendliness
- Low legal complexity
- Wide ecosystem integration

Choose a **copyleft license** if you want:

- Community improvements to remain available
- Stronger guarantees of software freedom
- Protection against proprietary redistribution of covered code

Neither approach is universally better.

They simply reflect different philosophies.

---

# 13. Comparison Tables

## Permissive vs Weak Copyleft vs Strong Copyleft

| Feature | Permissive | Weak Copyleft | Strong Copyleft |
|----------|------------|---------------|-----------------|
| Commercial Use | ✅ | ✅ | ✅ |
| Modify Source | ✅ | ✅ | ✅ |
| Redistribution | ✅ | ✅ | ✅ |
| Proprietary Applications | ✅ | Often yes | Limited by license obligations |
| Share Modifications | Not required | Required for covered components when distributed | Required for covered derivative works when distributed |
| Typical Goal | Maximum adoption | Balance | Preserve software freedoms |

---

## Popular Licenses

| Category | Examples |
|----------|----------|
| Permissive | MIT, BSD, Apache 2.0 |
| Weak Copyleft | LGPL, MPL 2.0 |
| Strong Copyleft | GPL v2, GPL v3, AGPL |

---

# 14. Decision Tree

```
Do you want maximum adoption?

        │

       Yes
        │

Choose a Permissive License

        │

   MIT / BSD / Apache

        │

       No
        │

Do you want improvements to remain open?

        │

       Yes
        │

Should only the library remain protected?

        │

       Yes
        │

Choose Weak Copyleft

(LGPL / MPL)

        │

       No
        │

Choose Strong Copyleft

(GPL / AGPL)
```

---

# 15. Key Takeaways

- Copyleft is a licensing philosophy, not a restriction on commercial use.
- Copyleft licenses generally allow commercial use, modification, and redistribution.
- Many copyleft obligations are triggered when software is distributed.
- Weak copyleft protects the licensed component while allowing broader flexibility for surrounding software.
- Strong copyleft places broader requirements on distributed derivative works.
- AGPL extends certain obligations to software provided over a network.
- Permissive and copyleft licenses pursue different goals rather than one being "better" than the other.

---

# 16. Final Summary

This handbook introduced the core concepts required to understand software licensing.

We covered:

### Foundations

- What is a software license?
- Why licenses exist
- Why licenses matter
- Copyright vs License
- Proprietary vs Open Source
- Source Available

### Licensing Terminology

- Source Code
- Binary
- Copyright
- Copyright Notice
- License Notice
- Attribution
- Redistribution
- Distribution vs Internal Use
- Commercial Use
- Private Use
- Derivative Works
- Linking
- Patent
- Patent Grant
- NOTICE Files
- Public Domain
- Forks
- Sublicensing

### Open Source License Categories

- Permissive Licenses
- Weak Copyleft
- Strong Copyleft

### Licensing Philosophies

- Maximum adoption through permissive licensing.
- Preservation of software freedoms through copyleft licensing.

With these concepts in place, you are now prepared to study individual licenses in detail.

---

# Next Document

The next handbook will focus on the licenses themselves:

## Permissive Licenses

- MIT License
- BSD License
- Apache License 2.0

## Copyleft Licenses

- LGPL
- MPL 2.0
- GPL v2 / GPL v3
- AGPL

Each license will be studied individually with:

- History
- Philosophy
- Permissions
- Obligations
- Restrictions
- Commercial use
- Redistribution rules
- Patent considerations
- Advantages
- Limitations
- Enterprise usage
- Real-world projects
- Practical examples
- Compatibility with other licenses