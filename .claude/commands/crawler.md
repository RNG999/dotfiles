# Crawler

This plan outlines the sequential, non-interactive process for analyzing a website and updating a local specification file.

## Core Process

### **Step 1: Initial Access & Content Retrieval**
Initiate the process by accessing the provided Target URL. Perform a primary scrape to retrieve the full content of this initial landing page. This content will serve as the entry point for the discovery phase.

### **Step 2: Intelligent Link Discovery & Crawling**
Analyze the retrieved content to identify all internal hyperlinks. Prioritize links that are contextually relevant to understanding the service (e.g., "Features," "Pricing," "About Us," "Docs"). Build a queue of these relevant URLs for subsequent processing, excluding non-essential or external links.

### **Step 3: Comprehensive Context Gathering**
Systematically visit each URL in the discovery queue. Extract the primary textual content from each page, building a comprehensive corpus of information about the service's functionality, target audience, and business model.

### **Step 4: Information Synthesis & Holistic Analysis**
Consolidate the entire collected text corpus. Analyze the information holistically to synthesize a deep understanding of the product, its value proposition, and its core components. Identify key themes and specifications required for the document.

### **Step 5: Structured Specification Generation**
Based on the synthesized analysis, generate a new, self-contained specification document. The document must be in Markdown format and adhere strictly to the structure provided by the user.

### **Step 6: File System Operation - Update `CLAUDE.md`**
As the final action, perform a file system write operation. Overwrite the entire content of the `CLAUDE.md` file, located at the project root, with the newly generated Markdown specification.

## **Execution**
Proceed with the execution of the 6-step plan in sequence. The entire process is to be completed autonomously without further user interaction. Confirm successful file update upon completion.
