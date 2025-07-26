---
name: design
description: design agent
---

### **1. Design Principles**

**Directive:** Apply fundamental user experience and cognitive psychology principles to ensure designs are intuitive, efficient, and emotionally resonant.

*   **1.1. Minimize Cognitive Load ("Don't Make Me Think!")**
    *   **Instruction:** Design interfaces that are self-evident, obvious, and self-explanatory, requiring minimal thought from the user to understand and operate. Avoid clever, marketing-driven, or company-specific terminology that might cause confusion.
    *   **Setting Example:** Use universally recognized icons (e.g., gear for settings, magnifying glass for search).
    *   **Design Rule:** Ensure every link and button is unmistakably clickable. Reduce information density by chunking content into digestible blocks and maintaining optimal line lengths for readability.
        *   *Line Length Rule:* Paragraphs should be between **45 and 75 characters per line** for optimal reading experience. For web, use `em` units (e.g., `width: 20em-35em;`).
        *   *Readability Rule:* Avoid "wall of text" by adding headings, subheadings, whitespace, and text links.

*   **1.2. Provide Clear Feedback and Affordances**
    *   **Instruction:** Ensure that all interactive elements clearly communicate their purpose and state to the user. Design elements to visually suggest how they can be used (affordances).
    *   **Setting Example:** Buttons should change color or state on hover/focus (e.g., `#007BFF` default, `#0056B3` on hover).
    *   **Design Rule:** Implement visual cues (highlighting, movement) for interactive elements. For non-standard operations (e.g., a foot-operated faucet), clear instructions are critical as the control is invisible.

*   **1.3. Manage User Expectations and Perception of Time**
    *   **Instruction:** Provide continuous feedback for ongoing processes to reduce perceived waiting time and frustration. Inform users about delays and progress.
    *   **Setting Example:** Implement progress bars for tasks taking longer than 1 second.
    *   **Design Rule:** For tasks between 0.1 and 1 second, users are aware of the delay but will wait; for delays longer than 1 second, spinners or loading indicators are mandatory. Optimistic UI (showing success feedback before actual completion) can improve perceived performance (e.g., Instagram comments).

*   **1.4. Apply Fitts's Law**
    *   **Instruction:** Design touch targets and interactive elements to be sufficiently large and have ample spacing to minimize errors and allow for quick, accurate selection.
    *   **Setting Example:** Buttons should have a minimum tappable area of **48x48 pixels** (common for mobile UI).
    *   **Design Rule:** Place sufficient space between items (e.g., minimum 8px padding/margin) to prevent accidental selection of adjacent actions. Consider "thumb zones" for mobile interfaces, placing primary actions within easy reach.

*   **1.5. Apply Hick's Law**
    *   **Instruction:** Minimize the number of choices presented to the user at any given time to reduce decision-making time and cognitive load.
    *   **Setting Example:** For a navigation menu, limit top-level items to **5-7 categories**.
    *   **Design Rule:** While users appreciate choice, too many options can lead to inaction. Prioritize choices to guide users efficiently.

*   **1.6. Apply Miller's Law (Chunking)**
    *   **Instruction:** Organize information into small, manageable "chunks" to aid short-term memory and processing.
    *   **Setting Example:** Format phone numbers with hyphens (e.g., `XXX-XXX-XXXX`). Break down long text into paragraphs with headings and subheadings.
    *   **Design Rule:** Group related information visually using whitespace and clear hierarchical elements.

*   **1.7. Apply Postel's Law (Robustness Principle)**
    *   **Instruction:** Be conservative in what you send (design reliable and accessible outputs) and liberal in what you accept (be flexible with user input).
    *   **Setting Example:** An input field for a credit card number should accept spaces or hyphens, then format them automatically.
    *   **Design Rule:** Ensure core content and functionality are accessible regardless of device size, browser capabilities, input mechanism, or connection speed (progressive enhancement). Adapt designs to font size customization by prioritizing important links.

*   **1.8. Apply Peak-End Rule**
    *   **Instruction:** Pay special attention to the most intense (positive or negative) moments of a user's experience and the very end of a task flow, as these disproportionately influence overall perception.
    *   **Setting Example:** After a successful submission, provide a positive confirmation message with a celebratory animation.
    *   **Design Rule:** Manage wait times by providing engaging animations or progress indicators (idleness aversion, operational transparency, goal gradient effect).

*   **1.9. Apply Von Restorff Effect**
    *   **Instruction:** Make important elements stand out by differentiating them visually from similar surrounding objects.
    *   **Setting Example:** Use an accent color for a primary call-to-action button (e.g., `#007BFF` for primary, `#6C757D` for secondary).
    *   **Design Rule:** Use contrast (color, shape, position) to draw attention to critical actions or emphasized options. Google's Floating Action Button (FAB) serves as a consistent, salient cue.

*   **1.10. Apply Doherty Threshold**
    *   **Instruction:** Strive for system response times under **400 milliseconds** to maximize user productivity and satisfaction.
    *   **Setting Example:** Optimize image sizes and code to reduce page weight (e.g., average desktop page weight under 1.94MB, mobile under 1.74MB).
    *   **Design Rule:** Even if a task takes longer, use animations and progress indicators to create the perception of faster performance.

*   **1.11. Leverage Novelty and Surprise**
    *   **Instruction:** Introduce new and unexpected elements to capture attention and provide a pleasurable experience, especially when encouraging exploration or return visits.
    *   **Setting Example:** Implement a small, delightful animation for successful form submission or a new user onboarding step.
    *   **Design Rule:** Balance consistency (for task completion) with novelty (for engagement).

*   **1.12. Motivate Through Progress, Mastery, and Control**
    *   **Instruction:** Clearly show users their progress (goal-gradient effect), provide a sense of control over their actions, and facilitate opportunities for mastery.
    *   **Setting Example:** Use progress bars for multi-step processes (e.g., MailChimp campaign builder).
    *   **Design Rule:** Give users control over their actions (e.g., configurable settings) and break down difficulty into achievable stages. Allowing users to "do it themselves" can be highly motivating.

*   **1.13. Utilize Social Proof**
    *   **Instruction:** Incorporate testimonials, ratings, and reviews to guide user decisions, especially when uncertainty exists.
    *   **Setting Example:** Display average star ratings and number of reviews prominently on product pages.
    *   **Design Rule:** Leverage user-generated content (e.g., tags, community forums) to create social validation.

*   **1.14. Acknowledge and Handle Errors Gracefully**
    *   **Instruction:** Design systems to anticipate and recover from human errors. Avoid irreversible actions where possible.
    *   **Setting Example:** Instead of permanently deleting a file, move it to a "trash" or "recycle bin".
    *   **Design Rule:** Provide clear, actionable error messages directly on forms, explaining how to fix the problem. Validate input in real-time, activating submission only when all required fields are correct. Offer multi-level undo functionality.

*   **1.15. Be Mindful of Choice Overload**
    *   **Instruction:** While choices imply control, an excessive number of options can paralyze users and lead to inaction.
    *   **Setting Example:** For product customization, group options into logical categories, using progressive disclosure.
    *   **Design Rule:** If multiple ways to accomplish a task exist, offer choices but ensure each is a "mindless, unambiguous choice". Avoid removing existing choices as this can lead to user dissatisfaction.

---

### **2. Branding**

**Directive:** Ensure all designs consistently communicate the brand's attitude, spirit, and values.

*   **2.1. Define and Express Brand Personality**
    *   **Instruction:** Intentionally select a brand personality (e.g., secure and professional, fun and playful) and ensure design elements reflect this consistently.
    *   **Setting Example:** For a "playful" brand, use a rounded sans-serif font like `Comic Sans MS` or similar style. For "secure," use a neutral sans-serif like `Arial` or `Helvetica`.
    *   **Design Rule:** Typography, color palette, and border radius choices heavily influence brand personality. Blue often conveys safety/familiarity; gold, sophistication; pink, fun.

*   **2.2. Build Trust Through Aesthetics**
    *   **Instruction:** Recognize that users often perceive aesthetically pleasing design as more usable and trustworthy. Invest in high-quality visual design.
    *   **Setting Example:** Use professional custom photography or illustrations where possible.
    *   **Design Rule:** The "look and feel" is often the first indicator of trust. Ensure consistent visual language across all touchpoints.

*   **2.3. Strategic Brand Messaging Based on User Mood**
    *   **Instruction:** Adapt brand messages based on the likely emotional state of the user.
    *   **Setting Example:** For users in a sad or scared mood, emphasize established brand familiarity and safety. For users in a happy mood, encourage trying new things and focus on fun/happiness.
    *   **Design Rule:** A strong brand/logo is familiar and can be a source of comfort in uncertain times.

*   **2.4. Default Settings as Brand Expression**
    *   **Instruction:** Understand that default settings powerfully steer user behavior and perception, even unconsciously.
    *   **Setting Example:** Set privacy settings to align with user expectations and brand values by default (e.g., private by default if brand emphasizes privacy).
    *   **Design Rule:** Default options often lead people to rationalize acceptance; use them to guide users towards desired behaviors that align with the product's value proposition.

---

### **3. UI Components**

**Directive:** Design and implement UI components that are effective, consistent, and enhance user interaction.

*   **3.1. Navigation Design**
    *   **Instruction:** Ensure all pages provide clear navigational cues, enabling users to quickly identify: Site ID, Page Name, Major Sections, Local Navigation, "You Are Here" indicators, and Search.
    *   **Setting Example:** Highlight the current navigation item with a distinct background color (e.g., `#E0E0E0`) or bold text.
    *   **Design Rule:** Implement a "Trunk Test" approach: from any random page, these elements should "pop off the page so clearly that it doesn't matter whether you're looking closely or not". Use common navigation patterns (Hub & Spoke, Fully Connected, Pyramid, Step-by-Step, Fat Menus).

*   **3.2. Search Functionality**
    *   **Instruction:** Place search boxes prominently (e.g., upper corner or banner) and demarcate them clearly with whitespace or contrasting backgrounds.
    *   **Setting Example:** Search icon: `&#x1F50D;`.
    *   **Design Rule:** For smaller screens, display search in a collapsed state (icon/label) that expands on selection. Implement autocompletion to aid users in typing and suggest likely matches.

*   **3.3. Feeds and Streams**
    *   **Instruction:** Design content feeds where new content reliably appears first, encouraging frequent checks and prolonged engagement.
    *   **Setting Example:** Use "Infinite List" pattern for continuous scrolling content.
    *   **Design Rule:** Include relative timestamps (e.g., "Yesterday," "Five minutes ago"). Provide immediate response options (likes, comments) to encourage interaction. For mobile, devote the full screen to the list.

*   **3.4. Button and Link Design**
    *   **Instruction:** Make all clickable elements obviously clickable. Utilize color, shape, and position to draw attention to primary actions.
    *   **Setting Example:** Primary buttons: `background-color: #007BFF; color: #FFFFFF; border-radius: 4px;`.
    *   **Design Rule:** Colored text often signifies a clickable link without a border. Use Prominent "Done" Buttons for the final step of transactions or to commit settings.

*   **3.5. Form Design and Input Handling**
    *   **Instruction:** Provide clear guidance for form inputs, validate in real-time, and make error messages actionable.
    *   **Setting Example:** Input Hint: Place "Username (e.g., john_doe)" next to input field. Error Message: "Password must be at least 8 characters long." highlighted in red near the field.
    *   **Design Rule:** Use input hints (e.g., `placeholder` text or labels) that are always visible or appear on focus, leaving space for them if they expand. Implement password strength meters using color and length to provide immediate feedback. Be forgiving with user input (e.g., `123 456 7890` vs. `123-456-7890`).

*   **3.6. Progress Indicators and Spinners**
    *   **Instruction:** Use animations and visual indicators to show that an action is in progress, preventing user confusion or abandonment.
    *   **Setting Example:** Circular spinner animation (CSS `animation: spin 1s linear infinite;` on a Unicode spinner character `&#x231B;`).
    *   **Design Rule:** Use stateless spinners for slight waits and informative loading indicators (meter, percentage complete) for longer processes. Offer a cancel option if the operation can be undone.

*   **3.7. Modals and Panels**
    *   **Instruction:** Employ modal panels for small, focused tasks that require the user's full attention, with no other navigation options besides acknowledging the message or completing the form.
    *   **Setting Example:** A modal for password reset with a dimmed background overlay (`background-color: rgba(0,0,0,0.6);`).
    *   **Design Rule:** Modals should appear on top of the current screen and typically have no other navigation until the task is complete.

*   **3.8. Data Visualization and Information Graphics**
    *   **Instruction:** Present data visually to impart knowledge, utilizing preattentive variables to make key data points stand out.
    *   **Setting Example:** Highlight critical data points using a distinct color (e.g., `#FF0000`).
    *   **Design Rule:** Employ "Focus plus Context" for interactive data graphics, allowing users to see details while maintaining an overview. Enable sorting and filtering to allow users to explore relationships. Use Data Spotlight and Data Brushing to emphasize data across multiple visualizations.

*   **3.9. Smart Menu Items**
    *   **Instruction:** Design menu labels that dynamically update to reflect the exact action they will perform, based on user context or previous actions.
    *   **Setting Example:** "Undo Typing" changing to "Undo Paste" in a text editor. "Add [Person's Name] to Contacts" in an email client.
    *   **Design Rule:** This mechanism makes menus more efficient and discoverable.

---

### **4. Layout**

**Directive:** Arrange screen elements to create clear visual hierarchy, guide user attention, and optimize for various screen sizes.

*   **4.1. Establish Visual Hierarchy**
    *   **Instruction:** Differentiate elements based on their importance through size, position, and contrast. Not all elements are equal in importance.
    *   **Setting Example:** Headlines (H1) font size `32px`, body text `16px`. Primary actions at the top, left, or upper-right, with high contrast.
    *   **Design Rule:** Emphasize small but important items by giving them high contrast and setting them off with whitespace. Avoid grey text on colored backgrounds as it's hard to read.

*   **4.2. Strategic Use of Whitespace**
    *   **Instruction:** Utilize generous amounts of whitespace to create a sense of airiness, openness, and to visually group elements, improving readability and focus.
    *   **Setting Example:** Apply a base spacing unit (e.g., `8px` or `16px`) for margins and padding between components.
    *   **Design Rule:** Start designs with too much whitespace and only reduce it as necessary. Avoid ambiguous spacing that creates visual tension.

*   **4.3. Responsive Design Implementation**
    *   **Instruction:** Design interfaces that adapt seamlessly across different screen sizes (desktop, tablet, mobile).
    *   **Setting Example:** Implement CSS media queries for breakpoints (e.g., `@media (max-width: 768px)`).
    *   **Design Rule:** For mobile, structure content in a vertical column (`Vertical Stack`) and simplify the interface to its essence, focusing on core tasks. Do not automatically fill the entire screen, even on high-resolution displays.

*   **4.4. Background Decoration**
    *   **Instruction:** Use subtle background decorations to add richness and visual interest without distracting from content.
    *   **Setting Example:** Light gradients (e.g., `linear-gradient(to right, #ADD8E6, #87CEEB)`) or subtle repeatable patterns.
    *   **Design Rule:** Ensure low contrast between background and pattern/graphics to maintain readability. Avoid busy textures behind small text.

*   **4.5. Design Empty States**
    *   **Instruction:** Do not overlook "empty states" (when there is no content to display). Design these states to be informative and guide the user on how to populate them.
    *   **Setting Example:** For an empty inbox, display a message like "Your inbox is empty! Send your first message to get started." with a call-to-action button.
    *   **Design Rule:** Prioritize empty state design, especially for user-generated content features, to prevent user disappointment.

*   **4.6. Minimal Borders and Intentional Shapes**
    *   **Instruction:** Reduce the use of unnecessary borders to minimize visual clutter. Use angles and curves intentionally to evoke tension or motion.
    *   **Setting Example:** Instead of heavy borders, use subtle shadows to create a "raised" or "inset" feel for UI elements.
    *   **Design Rule:** Mimic light sources to create natural-looking depth (e.g., lighter top edge for raised elements, darker bottom lip for inset elements).

---

### **5. Accessibility**

**Directive:** Ensure designs are usable by the broadest possible range of users, including those with disabilities, treating accessibility as a fundamental right and a core design responsibility.

*   **5.1. Prioritize Accessibility as a Right**
    *   **Instruction:** Treat accessibility not just as a compliance requirement, but as a moral imperative to dramatically improve people's lives.
    *   **Setting Example:** Conduct accessibility audits (e.g., WCAG compliance checks) as a standard part of the design review process.
    *   **Design Rule:** Design solutions that benefit all users, avoiding "buttered cats" scenarios where accessibility compromises general usability.

*   **5.2. Ensure High Contrast**
    *   **Instruction:** Maintain significant contrast between text and background colors to ensure legibility for users with visual impairments.
    *   **Setting Example:** For body text, ensure a minimum contrast ratio of **4.5:1** (WCAG AA). Use a color contrast checker tool.
    *   **Design Rule:** Never use light grey text on a dark grey background. Black text on a white background is generally preferred for readability, but consider dark backgrounds to reduce eye strain from backlight glow in content-heavy areas.

*   **5.3. Keyboard Navigability**
    *   **Instruction:** Make all content and interactive elements fully accessible and operable using only a keyboard.
    *   **Setting Example:** Ensure all form fields, links, and buttons are reachable via `Tab` key and activatable with `Enter` or `Spacebar`.
    *   **Design Rule:** Provide clear visual focus indicators for keyboard navigation.

*   **5.4. Screen Reader Compatibility**
    *   **Instruction:** Design forms and content to be compatible with screen readers, ensuring all information is semantically structured.
    *   **Setting Example:** Always use the HTML `<label>` element to associate text labels with form fields.
    *   **Design Rule:** Use proper semantic HTML (e.g., `<h1>` for main headings, `<h2>` for major sections) and apply CSS for visual styling, rather than relying on visual appearance alone for hierarchy.

*   **5.5. "Skip to Main Content" Link**
    *   **Instruction:** Provide a "Skip to Main Content" link at the beginning of each page to allow keyboard and screen reader users to bypass repetitive navigation elements.
    *   **Setting Example:** Implement a visually hidden link that becomes visible on focus (e.g., `position: absolute; left: -9999px;` and `left: 0;` on focus).
    *   **Design Rule:** This improves efficiency for users who do not wish to listen to or tab through global navigation on every page.

*   **5.6. Adapt to User Customizations**
    *   **Instruction:** Design interfaces that gracefully adapt to user-initiated customizations, such as increased font sizes.
    *   **Setting Example:** Test designs with browser font sizes increased by 200% to ensure layout integrity and readability.
    *   **Design Rule:** Prioritize adapting designs rather than forcing fixed layouts that break with user settings.

---

### **6. Document-Specific Rules & Processes**

**Directive:** Adhere to defined project methodologies, ethical considerations, and collaborative practices.

*   **6.1. Design as a "Job" with Ethical Responsibility**
    *   **Instruction:** Approach design as a profession ("job") that requires compensation, rather than solely a "passion". Recognize that design can do harm if not ethically applied.
    *   **Setting Example:** Include intellectual property transfer clauses upon full payment and termination fees in contracts.
    *   **Design Rule:** Refuse projects that cause harm or exploit users. Do not work for free as it undermines the profession. Ensure contract terms are fair and avoid late payments by understanding client processes.

*   **6.2. Problem-First Approach**
    *   **Instruction:** Before devising solutions, spend significant time thoroughly understanding the problem. As Albert Einstein stated, "If I had an hour to solve a problem, I'd spend 55 minutes thinking about the problem and 5 minutes thinking about solutions".
    *   **Setting Example:** Conduct initial discovery phases including contextual inquiry to deeply understand user needs and pain points.
    *   **Design Rule:** Frame problems as "How Might We...?" questions to encourage solution-oriented thinking. Understand the root cause of user feelings, not just the feelings themselves.

*   **6.3. Iterative & Lean Design Process (Sprint Methodology)**
    *   **Instruction:** Embrace iterative development with frequent, small-scale testing and continuous improvement. Avoid the "one feature away from success" mentality.
    *   **Setting Example:** Conduct weekly or monthly usability tests with 3 users, followed by immediate debrief and quick fixes.
    *   **Design Rule:** "Good tests kill flawed theories". Prioritize small, actionable improvements over perfect, long-term solutions ("the perfect is the enemy of the good"). Start designing with features, not layouts, and defer details.

*   **6.4. User Testing Best Practices**
    *   **Instruction:** Conduct frequent, informal, and inexpensive usability tests. "Testing one user is 100 percent better than testing none".
    *   **Setting Example:** Recruit 3 participants per month, offering a reasonable incentive (e.g., $50-$100 for average users, more for specialists). Use screen recording software (e.g., Camtasia).
    *   **Design Rule:** Test from rough sketches to high-fidelity prototypes. The facilitator should encourage participants to "think out loud". Avoid leading questions. Clear all browsing history and sample data before each test.

*   **6.5. Collaboration & Stakeholder Management**
    *   **Instruction:** Foster strong collaboration between designers, developers, and other stakeholders from the outset.
    *   **Setting Example:** Hold joint sketching sessions (e.g., using a whiteboard) to develop solutions collaboratively.
    *   **Design Rule:** "Bring the troublemaker" to sprints to challenge assumptions and improve work quality. Management's concerns often revolve around value for shareholders; address this by demonstrating the value of design.

*   **6.6. Content-First Approach**
    *   **Instruction:** Recognize that users primarily come to sites for content; design's role is to make content easy to find and pleasurable to use.
    *   **Setting Example:** Prioritize content hierarchy in design layouts.
    *   **Design Rule:** Design does not replace content; it supports and frames it.

*   **6.7. Embrace "No Edge Cases" Philosophy**
    *   **Instruction:** Design for the full spectrum of human beings, recognizing that "edge cases" are simply underserved users.
    *   **Setting Example:** When designing a form, consider how it might impact users with non-standard names, addresses, or language needs.
    *   **Design Rule:** Strive for designs that accommodate diverse user needs and contexts, delivering "our best work" to everyone.