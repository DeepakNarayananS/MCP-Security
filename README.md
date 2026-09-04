# MCP Security Lab with Cisco MCP Scanner

A hands-on security lab for learning and testing the security risks associated with the Model Context Protocol (MCP).

This project uses an intentionally vulnerable local MCP server and Cisco's MCP Scanner to demonstrate how MCP tools can introduce security risks such as prompt injection, data exposure, instruction override, indirect injection, input validation issues, and tool misuse.

> ⚠️ **LAB ONLY**
>
> This project is intentionally vulnerable and is created strictly for security learning, research, and demonstration purposes.
>
> Do not connect this lab to production systems, real credentials, customer data, corporate infrastructure, or sensitive files.


## 🎯 Project Objective

MCP is becoming an important part of the AI ecosystem by allowing AI applications and agents to interact with external tools, data sources, APIs, files, and services.

As MCP adoption grows, understanding the security implications of these integrations becomes increasingly important.

The objective of this lab is to provide a practical environment where you can:

- Understand how an MCP server works
- Understand how MCP tools expose capabilities to AI agents
- Identify security risks in MCP tool implementations
- Scan MCP configurations using Cisco MCP Scanner
- Analyze Prompt Defense findings
- Map scanner findings back to the vulnerable server implementation
- Generate raw JSON security results
- Convert the JSON findings into a readable HTML security report
- Develop an MCP security mindset from a defensive perspective


## 🧩 Lab Architecture

```text
                    Windows 11
                        │
                        ▼
             ┌─────────────────────┐
             │  Vulnerable MCP     │
             │      Server         │
             │     server.py       │
             └──────────┬──────────┘
                        │
                        │ MCP / stdio
                        ▼
             ┌─────────────────────┐
             │      mcp.json       │
             │ MCP Server Config   │
             └──────────┬──────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │ Cisco MCP Scanner   │
             │ cisco-mcp-scan venv │
             └──────────┬──────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │ Prompt Defense      │
             │     Analysis        │
             └──────────┬──────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │ cisco-mcp-results   │
             │       .json         │
             └──────────┬──────────┘
                        │
                        ▼
             ┌─────────────────────┐
             │ HTML Security       │
             │      Report         │
             └─────────────────────┘
🔐 Why MCP Security Matters

MCP allows AI applications to interact with external capabilities through tools.

A tool may potentially:

Read files
Modify files
Access APIs
Query databases
Send messages
Execute actions
Process external content
Access sensitive information

The security risk therefore depends not only on the AI model itself, but also on the permissions and behavior of the tools connected to it.

A useful MCP security review should consider:

AI Model
   ↓
MCP Client
   ↓
MCP Server
   ↓
Tool Description
   ↓
Tool Permissions
   ↓
Input Validation
   ↓
Data Access
   ↓
External Systems

The complete tool-to-tool and data flow needs to be considered when assessing the security of an MCP environment.

🛡️ Why Cisco MCP Scanner?

This project uses Cisco MCP Scanner to perform security analysis against the intentionally vulnerable MCP environment.

Cisco AI Defense focuses on security for AI applications, agents, models and MCP-based workflows.

The scanner provides multiple analysis capabilities, including security analysis of MCP tools, prompts, resources, instructions and other MCP components.

For this lab, the primary demonstration focuses on Prompt Defense analysis.

API note

This lab demonstrates a local scanning workflow that does not require a Cisco AI Defense API key.

This should not be interpreted as meaning that every Cisco MCP Scanner feature or Cisco AI Defense capability is API-free. Different scanner analyzers and Cisco AI Defense integrations may have different requirements.

🧪 Vulnerable MCP Server

The MCP server in this project is intentionally designed with insecure patterns so that security scanners have meaningful behavior to analyze.

The lab includes examples of MCP tools such as:

add_numbers
multiply_numbers
get_website_comments
get_api_key
send_email
delete_file

These tools are deliberately created for security testing.

The purpose is not to build a functional production MCP application.

The purpose is to understand:

What happens when an AI agent is given access to tools that have excessive permissions, weak input validation, unsafe instructions, or insecure data-handling behavior?

📁 Project Structure
snyk_mcp_vulnerable_lab/
│
├── server.py
│   └── Intentionally vulnerable MCP server
│
├── mcp.json
│   └── MCP server configuration used by the scanner
│
├── pyproject.toml
│   └── Python project configuration and MCP dependency
│
├── setup.ps1
│   └── Lab setup helper
│
├── scan-cisco.ps1
│   └── Interactive Cisco MCP Scanner launcher
│
├── cisco-mcp-scan/
│   └── Dedicated Python virtual environment for Cisco MCP Scanner
│
├── cisco-mcp-results.json
│   └── Raw scanner output generated after the scan
│
└── README.md
    └── Project documentation
💻 Windows 11 Setup
Prerequisites

The lab was designed for Windows 11.

Install the following:

Python 3.11 or later
uv
Visual Studio Build Tools
Microsoft C++ build tools
Windows SDK
Developer PowerShell for Visual Studio
1. Install Visual Studio Build Tools

Install Build Tools for Visual Studio.

During installation, select:

Desktop development with C++

Make sure the required C++ build tools and Windows SDK components are installed.

After installation, restart Windows if requested.

2. Open Developer PowerShell for Visual Studio

Open:

Developer PowerShell for VS

Using Developer PowerShell ensures that the Visual Studio development environment and required build tools are available in the shell.

3. Navigate to the Lab
cd "C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab"
🐍 Create the Cisco Scanner Virtual Environment

Create a dedicated environment for the Cisco scanner:

uv venv cisco-mcp-scan --python 3.13

Activate it:

.\cisco-mcp-scan\Scripts\Activate.ps1

The PowerShell prompt should now look similar to:

(cisco-mcp-scan) PS C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab>
Install Cisco MCP Scanner
uv pip install cisco-ai-mcp-scanner

Verify the installation:

mcp-scanner --help

You can also verify the installed package:

uv pip show cisco-ai-mcp-scanner
⚙️ MCP Configuration

The mcp.json file tells the scanner how to start the local MCP server.

Example:

{
  "mcpServers": {
    "Snyk MCP Vulnerable Lab": {
      "type": "stdio",
      "command": "uv",
      "args": [
        "run",
        "--project",
        "C:\\Users\\DEEPAK\\Documents\\snyk_mcp_vulnerable_lab",
        "python",
        "server.py"
      ]
    }
  }
}

Make sure the project path points to the directory containing:

server.py
pyproject.toml

Do not leave:

REPLACE_WITH_LAB_PATH

in the configuration.

🔎 Run the Cisco MCP Scan

With the Cisco environment activated:

mcp-scanner --analyzers prompt_defense --raw config --config-path ".\mcp.json"

This scans the MCP configuration and performs the selected analyzer against the configured MCP server.

📄 Save the Scan Results

To save the complete raw output as JSON:

mcp-scanner --analyzers prompt_defense --raw config --config-path ".\mcp.json" > ".\cisco-mcp-results.json"

Verify the file exists:

Test-Path ".\cisco-mcp-results.json"

Expected result:

True
🚀 Using scan-cisco.ps1

The repository includes an interactive PowerShell script to make repeated scans easier.

From the lab directory:

cd "C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab"

.\scan-cisco.ps1

The script provides options similar to:

============================================
 Cisco MCP Scanner - Vulnerable MCP Lab
============================================

  1. Run normal scan
  2. Update Cisco MCP Scanner and run scan
  3. Exit

Select an option:
Option 1

Runs the currently installed scanner version.

Option 2

Updates the Cisco MCP Scanner package and then runs the scan.

The update operation is:

uv pip install --upgrade cisco-ai-mcp-scanner
Option 3

Exits the script.

🔄 Updating Cisco MCP Scanner

If you want to manually update the scanner, activate the Cisco environment first:

cd "C:\Users\DEEPAK\Documents\snyk_mcp_vulnerable_lab"

.\cisco-mcp-scan\Scripts\Activate.ps1

Then:

uv pip install --upgrade cisco-ai-mcp-scanner

Verify:

uv pip show cisco-ai-mcp-scanner

The scan-cisco.ps1 script can also perform this update automatically using Option 2.

📊 Understanding the Findings

The scanner output should be reviewed tool by tool.

For example, a tool may produce a result similar to:

Tool: delete_file
Status: completed
Safe: No

Analyzer:
promptdefense_analyzer

Severity:
HIGH

The report may identify security categories such as:

Direct Prompt Injection
Data Exfiltration / Exposure
Indirect Prompt Injection
Harmful Content Generation
Denial of Service
Model or Agentic System Manipulation
Instruction Override
Data Leakage
Input Validation
Abuse Prevention
🔍 Map Findings Back to the Code

Do not stop at the scanner output.

For every interesting finding:

Scanner Finding
       ↓
Analyzer
       ↓
Threat Category
       ↓
MCP Tool
       ↓
server.py
       ↓
Actual Behavior
       ↓
Potential Security Impact

This is one of the main learning objectives of the lab.

The goal is to understand why the scanner produced a finding rather than simply collecting a list of vulnerabilities.

🌐 Generate an HTML Security Report

The raw JSON is useful for preserving the scanner evidence, but it is not always convenient for presentation.

You can use an organization's approved AI tool to transform:

cisco-mcp-results.json

into:

cisco-mcp-security-report.html

The HTML should act only as a presentation layer.

The JSON remains the source of truth.

⚠️ Important Data Security Warning

Never upload production security reports, logs, configurations, credentials, customer information, proprietary information, or other sensitive data to an AI service without appropriate organizational approval.

Before using an AI service:

Follow your organization's AI usage policy
Use an approved AI service
Sanitize sensitive information where required
Remove credentials and secrets
Remove customer or personal information
Remove proprietary information where applicable

Sharing sensitive security information with an unauthorized AI service can itself create a data-exposure risk.

This project uses intentionally generated lab data for learning purposes.

🤖 Prompt for JSON-to-HTML Conversion

Attach:

cisco-mcp-results.json

to your approved AI tool and use the following prompt:

I have attached a JSON file named "cisco-mcp-results.json" generated by Cisco MCP Scanner.

Convert this JSON into a complete, professional, visually polished HTML security assessment report.

IMPORTANT:

The JSON is the source of truth and the HTML is only the presentation layer.

Do NOT summarize away findings.
Do NOT truncate descriptions.
Do NOT invent information.
Do NOT change severity or security meaning.
Do NOT merge findings from different analyzers.
Preserve all information contained in the JSON.

REPORT TITLE:

"Cisco MCP Scanner - Lab Findings Report"

Create the report with the following sections:

1. EXECUTIVE SUMMARY

Display:

- MCP server name
- Number of tools scanned
- Number of safe tools
- Number of unsafe tools
- Number of HIGH severity findings
- Number of MEDIUM severity findings
- Number of LOW severity findings
- Total findings

Calculate these values directly from the JSON.

2. SCAN INFORMATION

Display:

- Server name
- Scan status
- Analyzer names
- Scan configuration if available
- Total findings

Preserve analyzer names exactly as they appear in the JSON.

3. TOOL-BY-TOOL FINDINGS

Create a separate section/card for every tool.

For each tool display:

- Tool name
- Server name
- Status
- Safe/Unsafe status
- Analyzer name
- Severity
- Threat summary
- Threat names
- Total findings

4. ANALYZER RESULTS

If a tool contains results from multiple analyzers, display each analyzer separately.

Do not merge similarly named analyzers.

5. THREAT DETAILS

For every threat display:

- Threat name
- Severity
- AITech
- AISubtech
- AISubtech Name
- Full description
- Any additional fields contained in the JSON

Do not truncate descriptions.

6. MCP TAXONOMY

Where taxonomy information exists, create a readable table containing:

- AITech
- AISubtech
- AISubtech Name
- Description

Ensure long descriptions wrap correctly.

7. EXPANDABLE DETAILS

Use native HTML <details>/<summary> sections for long descriptions and taxonomy information.

The complete text must remain available.

8. VISUAL DESIGN

Create a professional cybersecurity-report layout with:

- Clean typography
- Consistent spacing
- Proper alignment
- Rounded cards
- Severity badges
- Threat chips/tags
- Readable tables
- Good whitespace
- Responsive layout

The report should look suitable for:

- Cybersecurity presentations
- Security documentation
- Technical blogs
- Community demonstrations

9. RESPONSIVE DESIGN

The HTML must work properly on desktop, laptop, tablet and mobile.

Prevent long descriptions and tables from overflowing horizontally.

10. PRINT / PDF SUPPORT

Add print-friendly CSS so the report can be printed or saved as PDF without content being cut off.

11. VISUAL SUMMARY

If the JSON contains sufficient information, create simple visual summaries for:

- Safe vs Unsafe tools
- Findings by severity
- Findings by analyzer

Use only information that can be accurately calculated from the JSON.

Do not invent data.

12. SEARCH

Add a simple vanilla JavaScript search/filter capability for:

- Tool name
- Threat name
- Analyzer
- Severity
- Taxonomy

Do not use external JavaScript libraries.

13. SOURCE & METHODOLOGY

Add a section named:

"Source & Methodology"

Include:

"This report is a presentation layer generated from the supplied Cisco MCP Scanner JSON output. The JSON file is treated as the source of truth. Security findings and their meanings have not been modified."

Source file:

cisco-mcp-results.json

14. DISCLAIMER

Include:

"This is a community/lab presentation report generated from Cisco MCP Scanner output. It is not an official Cisco-generated HTML report and should not be interpreted as a Cisco security certification or official Cisco assessment."

15. DATA INTEGRITY

Before generating the HTML, verify that:

- Every tool is represented
- Every analyzer result is represented
- Every finding is represented
- Every threat name is represented
- Every taxonomy entry is represented
- Every description is preserved
- Safe/Unsafe status is preserved
- Severity values are preserved

If the JSON contains multiple analyzer entries, preserve each one separately.

16. OUTPUT

Return ONE complete standalone HTML document.

The HTML must contain:

- <!DOCTYPE html>
- <html>
- <head>
- Embedded CSS
- Embedded JavaScript if required
- <body>
- Complete report content

Do not use external CSS.
Do not use external JavaScript libraries.
Do not use external images.
Do not require an internet connection.

The final file should be saveable as:

cisco-mcp-security-report.html

Before finishing, verify that no information from the JSON was accidentally truncated or omitted.
🧠 Key Security Learning

The main purpose of this project is not simply to demonstrate that a scanner can identify vulnerabilities.

The bigger objective is to understand the security relationship between:

AI
 ↓
MCP Client
 ↓
MCP Server
 ↓
Tool Description
 ↓
Tool Permissions
 ↓
Input Validation
 ↓
Data Access
 ↓
Tool-to-Tool Data Flow
 ↓
External Systems

When reviewing an MCP implementation, consider:

What can the tool access?
What permissions does it have?
What instructions are provided to the model?
Can user-controlled input influence the tool?
Can external content influence the model?
Can one tool's output influence another tool?
What sensitive information can flow through the agent?
What happens if the model is manipulated?
⚠️ Lab Safety

This project intentionally contains vulnerable behavior.

Do not:

Add real API keys
Add real passwords
Add production credentials
Connect production databases
Connect corporate email accounts
Use real customer data
Point tools toward sensitive directories
Expose the MCP server to the public internet
Use the vulnerable server in production

Use only synthetic data and disposable test resources.

📚 Learning Approach

A useful way to work through this lab is:

1. Build
   ↓
2. Understand
   ↓
3. Scan
   ↓
4. Review Finding
   ↓
5. Locate Tool
   ↓
6. Inspect server.py
   ↓
7. Understand Data Flow
   ↓
8. Identify Security Impact
   ↓
9. Think About Mitigation

The scanner should be treated as a security analysis aid, not as a replacement for manual security review.

🔗 References
Cisco AI Defense
Cisco MCP Scanner
Model Context Protocol
Microsoft Visual Studio Build Tools
Microsoft Developer PowerShell for Visual Studio

Refer to the official documentation for the latest installation requirements, scanner capabilities, analyzer availability, and product changes.

📌 Disclaimer

This repository is an independent educational cybersecurity project.

The MCP server is intentionally vulnerable and should only be used in an isolated lab environment.

Cisco MCP Scanner is used as a security analysis tool for this educational demonstration. This project is not affiliated with, sponsored by, or endorsed by Cisco unless explicitly stated by Cisco.

Any security findings demonstrated in this repository are intended for educational purposes and should not be interpreted as a production security assessment.

⭐ If You Find This Useful

If this lab helps you understand MCP security, feel free to:

⭐ Star the repository
Fork the project
Experiment in an isolated lab
Share your learning
Contribute improvements

Security learning becomes more valuable when we build, test, understand and share.