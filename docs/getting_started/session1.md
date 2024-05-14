---
layout: default
parent: Getting Started
title: Session I
nav_order: 2
---
# The Basic Guided Tour

### Suggeted Readings
* [Getting Started](..%2Fgetting_started.md)
* [Prerequisite](prerequisite.md)

## Basic AnyLog commands

The basic AnyLog commands demonstrated in the Onboarding session:

<ul>
    <li><b>Help commands</b> - See details in <a href="https://github.com/AnyLog-co/documentation/blob/master/getting%20started.md#the-help-command" target="blank">the help command section</a>
        <pre class="code-frame"><code class="language-anylog">help
help index
help index streaming
help run kafka consumer</code></pre></li>
    <li><b>Log Events</b> - Logs that track events - logs examples: <code class="language-anylog">event log</code>, 
<code class="language-anylog">error log</code>, <code class="language-anylog">rest log</code>, 
<code class="language-anylog">query log</code> (needs to be enabled).
    <pre class="code-frame"><code class="language-anylog">get event log
get error log</code></pre>
</li>
    <li><b>Node Name</b> - The name on the CLI prompt can be set by the user to identify the node when multiple CLIs are used.
    <pre class="code-frame"><code class="language-anylog">node_name = generic
# The assignment above makes the CLI prompt appear as:
EL generic >
</code></pre>
</li>
    <li>Local Directories - The local dictionary maps local values (like paths names and IPs) to unified names that can 
be shared across nodes. Farther Details
    <ul>
        <li><a href="https://github.com/AnyLog-co/documentation/blob/master/dictionary.md#the-local-dictionary" target="_blank">the local dictionary section</a></li>
        <li><a href="..%2Fgetting_started.md/#nodes-directory-structure">Getting Started</a></li>
    </ul>
    <pre class="code-frame"><code class="language-anylog">get dictionary
abc = 123
!abc
!blockchain_file
get env var
$HOME

# Use the local dictionary to see the local folders' setup:
get dictionary _dir
</code></pre>
</li>
</ul>
