---
name: code
description: coding agent
---

## Comprehensive Custom Instructions for Coding Agents

This document outlines a comprehensive set of instructions for coding agents, derived from a thorough analysis of best practices in software development. The goal is to ensure the generation of high-quality, reliable, maintainable, scalable, and secure code. Each instruction is self-contained, providing sufficient detail for immediate application without external references.

### 1. Domain Model Integrity (Always-Valid Domain Model)

The core principle here is to ensure that domain objects are always in a valid state, both upon creation and throughout their lifecycle. This prevents the creation of invalid objects and shifts the responsibility of validation from the calling side to the domain object itself. This approach is fundamental to maintaining business consistency and is achieved by designing with types, eliminating "loose" types that can hold anything, and addressing implicit relationships between multiple attributes.

**Key Points:**
*   **Validation within Constructor:** Prevent invalid objects from being created by enforcing validation rules in the constructor.
*   **Design with Types:** Use specific types to represent business rules and valid states, especially for atomic attributes and related state transitions. This also relates to Type-First Development (TFD).
*   **Separate Validated States:** For attributes with state-dependent validity (e.g., verified email), define distinct types for each state (e.g., `UnverifiedEmailAddress` and `VerifiedEmailAddress`).

**Sample Code/Configuration:**

```java
// BEFORE: Validation logic is external and can be forgotten.
public class RegisterMemberUseCase {
    private SaveMemberPort saverMemberPort;
    void register(RegisterMemberCommand command) {
        if (!command.getEmailAddress().matches("^\\S+@\\S+\\.\\S+$")) { // Easily forgotten
            throw new IllegalArgumentException();
        }
        Member member = new Member(command.getEmailAddress());
        saveMemberPort.save(member);
    }
}

// AFTER: Validation is encapsulated within the Member constructor, ensuring Always-Valid state.
// This is the preferred approach for Always-Valid Domain Models.
@Getter
public class Member {
    String emailAddress;

    public Member(String emailAddress) {
        if (!emailAddress.matches("^\\S+@\\S+\\.\\S+$")) {
            throw new IllegalArgumentException("Invalid email address format.");
        }
        this.emailAddress = emailAddress;
    }
    // No `isValid()` method as the object is always valid by design.
}

// Example of designing with types for state-dependent validity.
// `EmailAddress` as an abstract base type.
@Getter
public abstract class EmailAddress {
    String value;
    // Constructor to set the value
    EmailAddress(String value) {
        this.value = value;
    }
}

// `VerifiedEmailAddress` can only be created via a verification process.
public class VerifiedEmailAddress extends EmailAddress {
    VerifiedEmailAddress(String value) {
        super(value);
        // Additional logic for verification success could be here, or enforced by the service.
    }
}

// `UnverifiedEmailAddress` represents an unverified state.
public class UnverifiedEmailAddress extends EmailAddress {
    public UnverifiedEmailAddress(String value) {
        super(value);
    }
}

// Services interact with specific types, enforcing business rules at the type level.
public interface VerifyEmailService {
    VerifiedEmailAddress verify(UnverifiedEmailAddress emailAddress);
}

public interface SendNotificationService {
    void send(VerifiedEmailAddress emailAddress); // Only verified emails can receive notifications
}

// Member class uses the EmailAddress abstraction.
public class Member {
    EmailAddress emailAddress;
    // Constructor and other methods would ensure the correct EmailAddress type is used.
}
```

### 2. Architectural Design Principles

Adhering to robust architectural principles is crucial for building maintainable, scalable, and flexible systems.

**Key Points:**
*   **Clean Architecture:** Design systems where the core business logic (domain model) is independent of external details like databases, UIs, and frameworks. This promotes testability and flexibility.
*   **Dependency Inversion Principle (DIP) and Dependency Injection (DI):** Depend on abstractions, not concrete implementations. DI enables loose coupling, making systems more flexible, testable, and maintainable.
*   **Humble Object Pattern:** Separate behaviors that are hard to test from those that are easy to test. The "humble" part (e.g., UI, database access) is minimal and hard to test, while the testable logic is extracted.
*   **Microservices:** Consider breaking down large systems into smaller, independently deployable services, being mindful of the complexities introduced (e.g., distributed transactions, data consistency).

**Sample Code/Configuration:**

```java
// Clean Architecture / DIP Example (Conceptual)
// Core Domain Interface (Abstraction)
public interface MemberRepository {
    void save(Member member);
    Member findById(MemberId id);
}

// Application Service (depends on abstraction)
public class RegisterMemberApplicationService {
    private final MemberRepository memberRepository; // Depends on interface

    public RegisterMemberApplicationService(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    public void register(RegisterMemberCommand command) {
        // Business logic
        Member member = new Member(command.getEmailAddress()); // Always-Valid domain object
        memberRepository.save(member);
    }
}

// Infrastructure Implementation (Concrete)
public class JpaMemberRepository implements MemberRepository {
    // JPA specific implementation
    @Override
    public void save(Member member) {
        // Save to database
    }

    @Override
    public Member findById(MemberId id) {
        // Fetch from database
        return null; // Placeholder
    }
}

// Dependency Injection (Conceptual using a DI container)
// In a framework like Spring or Guice, this would be configured.
// For example, using a Simple Injector like approach:
// var container = new Container();
// container.Register<IMemberRepository, JpaMemberRepository>();
// container.Register<RegisterMemberApplicationService>();
//
// Registering a specific type for an abstraction
// services.AddTransient<IMemberRepository, JpaMemberRepository>();

// Humble Object Pattern (Conceptual for a UI)
// Untestable UI component (Humble Object)
public interface MemberView {
    void displayMember(MemberDto member);
    String getEmailInput();
}

// Testable Presenter
public class MemberPresenter {
    private MemberView view;
    private MemberApplicationService service;

    public MemberPresenter(MemberView view, MemberApplicationService service) {
        this.view = view;
        this.service = service;
    }

    public void onRegisterClicked() {
        String email = view.getEmailInput();
        try {
            service.register(new RegisterMemberCommand(email));
            view.displaySuccessMessage("Member registered!");
        } catch (IllegalArgumentException e) {
            view.displayErrorMessage("Invalid email format.");
        }
    }
}
```

### 3. Coding Practices and Quality

Clean code is paramount for readability, maintainability, and collaboration.

**Key Points:**
*   **Meaningful Names:** Use names that clearly convey intent and context. Avoid abbreviations or generic terms unless universally understood.
*   **Small Functions/Methods:** Keep functions small and focused on a single responsibility. This improves readability and testability.
*   **Comments:** Use comments sparingly and only when code cannot express its intent. Avoid redundant, misleading, or too much historical information. `@Ignore` for long tests is a good use case.
*   **Error Handling:** Use exceptions for truly exceptional conditions and define them in terms of the caller's needs. Prefer returning result objects (e.g., `Either`, `Result`) for expected failure paths, especially in functional styles. Avoid returning or passing `null`.
*   **Immutability:** Favor immutable objects, especially for Value Objects, to ensure their state cannot be changed after creation. This simplifies reasoning about the code and reduces side effects.
*   **Concurrency:** Handle concurrency explicitly and carefully, being aware of potential issues like race conditions and deadlocks. Use appropriate synchronization mechanisms. For Go, `GOMAXPROCS` can control CPU usage.

**Sample Code/Configuration:**

```java
// Error Handling: Using a Result type for expected outcomes
// Instead of throwing an InsufficientFundsException, return a Result.
public final class Account {
    private long balance; // Assume Amount is a Value Object here

    public Result transfer(final Amount amount, final Account toAccount) {
        // Validation using utility (example)
        // notNull(amount);
        // notNull(toAccount);

        if (balance().isLessThan(amount)) {
            return Result.failure(FailureType.INSUFFICIENT_FUNDS); // Expected failure path
        }
        return executeTransfer(amount, toAccount); // Returns Result.success()
    }

    private Result executeTransfer(Amount amount, Account toAccount) {
        // Actual transfer logic
        this.balance -= amount.getValue();
        toAccount.balance += amount.getValue();
        return Result.success();
    }

    public Amount balance() {
        return new Amount(this.balance);
    }
}

// Result.java (simplified)
public class Result {
    private final FailureType failure;
    private final boolean isSuccess;

    private Result(boolean isSuccess, FailureType failure) {
        this.isSuccess = isSuccess;
        this.failure = failure;
    }

    public static Result success() {
        return new Result(true, null);
    }

    public static Result failure(FailureType type) {
        return new Result(false, type);
    }

    public boolean isSuccess() {
        return isSuccess;
    }

    public boolean isFailure() {
        return !isSuccess;
    }

    public Optional<FailureType> failure() {
        return Optional.ofNullable(failure);
    }

    public enum FailureType {
        INSUFFICIENT_FUNDS,
        // ... other failure types
    }
}

// Concurrency in Go: GOMAXPROCS
// Set the number of logical CPUs that the program can use.
// Default is the number of virtual CPU cores exposed by the OS, which is usually optimal.
// Can be set via environment variable or runtime function.
// Environment variable:
// GOMAXPROCS=4 go run your_app.go
// In code:
package main

import (
	"fmt"
	"runtime"
	"sync"
)

func main() {
	// Set GOMAXPROCS to 2 (for example, to reduce parallelism for testing)
	runtime.GOMAXPROCS(2)
	fmt.Printf("GOMAXPROCS: %d\n", runtime.GOMAXPROCS(-1))

	var wg sync.WaitGroup
	for i := 0; i < 10; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			// Simulate some work
			sum := 0
			for j := 0; j < 1_000_000; j++ {
				sum += j
			}
			fmt.Printf("Goroutine %d finished with sum %d\n", id, sum)
		}(i)
	}
	wg.Wait()
}
```

### 4. Testing Strategy

Robust testing is fundamental to ensure software quality and facilitate safe refactoring and evolution.

**Key Points:**
*   **Test-Driven Development (TDD):** Write tests before writing production code. This guides design, ensures testability, and reduces defects.
*   **Unit Tests:** Focus on testing individual units (e.g., classes, methods) in isolation. They should be fast, reliable, and deterministic.
*   **Meaningful Test Names:** Test names should clearly describe the behavior being tested and the conditions under which it's tested (e.g., `Delivery_with_a_past_date_is_invalid()`).
*   **Test Doubles (Mocks, Stubs, Spies):** Use test doubles to isolate the System Under Test (SUT) from its dependencies, especially out-of-process ones (databases, network services).
*   **Integration Tests:** Cover the "longest happy path" and edge cases that involve multiple components or external dependencies.
*   **Automated Teardown:** Ensure test fixtures are cleaned up automatically after each test to prevent test interference and maintain test independence.

**Sample Code/Configuration:**

```java
// Unit Test Naming Convention (Java/C# like)
// MethodName_StateUnderTest_ExpectedBehavior
public class DeliveryServiceTests {

    // Test for a delivery with a past date
    @Test
    public void Delivery_with_a_past_date_is_invalid() {
        // Arrange: Prepare test data and SUT
        Delivery delivery = new Delivery(LocalDate.now().minusDays(1), "Some Address");

        // Act: Invoke the method under test
        boolean isValid = delivery.isValid();

        // Assert: Verify the outcome
        assertFalse(isValid);
    }

    // Test for a delivery with a future date
    @Test
    public void Delivery_with_a_future_date_is_valid() {
        // Arrange
        Delivery delivery = new Delivery(LocalDate.now().plusDays(1), "Some Address");

        // Act
        boolean isValid = delivery.isValid();

        // Assert
        assertTrue(isValid);
    }
}

// Test Double - Stub Example (Java)
// SUT: TimeDisplay, which depends on TimeProvider
public interface TimeProvider {
    Calendar getTime(String timeZone);
}

public class TimeDisplay {
    private TimeProvider timeProvider;

    public void setTimeProvider(TimeProvider timeProvider) {
        this.timeProvider = timeProvider;
    }

    public String getCurrentTimeAsHtmlFragment() {
        Calendar currentTime = timeProvider.getTime("UTC");
        if (currentTime.get(Calendar.HOUR_OF_DAY) == 0 && currentTime.get(Calendar.MINUTE) == 0) {
            return "<span class=\"tinyBoldText\">Midnight</span>";
        }
        return "Time: " + currentTime.getTime().toString();
    }
}

// Test Class using a Test Stub
public class TimeDisplayTest {

    // Test Stub implementation for predictable time
    class MidnightTimeProviderStub implements TimeProvider {
        @Override
        public Calendar getTime(String timeZone) {
            Calendar myTime = new GregorianCalendar();
            myTime.set(Calendar.HOUR_OF_DAY, 0);
            myTime.set(Calendar.MINUTE, 0);
            myTime.set(Calendar.SECOND, 0);
            myTime.set(Calendar.MILLISECOND, 0);
            return myTime;
        }
    }

    @Test
    public void testDisplayCurrentTime_AtMidnight() throws Exception {
        // Fixture setup: Instantiate SUT and inject Test Stub
        TimeDisplay sut = new TimeDisplay();
        sut.setTimeProvider(new MidnightTimeProviderStub());

        // Exercise SUT: Call the method under test
        String result = sut.getCurrentTimeAsHtmlFragment();

        // Verify outcome: Assert the expected result
        String expectedTimeString = "<span class=\"tinyBoldText\">Midnight</span>";
        assertEquals(expectedTimeString, result);
    }
}

// Automated Teardown (Example in JUnit)
public class DatabaseTest {

    @BeforeEach // JUnit 5 equivalent of @Before
    void setUp() {
        // Setup database fixture (e.g., populate with test data)
        // This is where a Transaction Rollback Teardown might begin a transaction.
    }

    @AfterEach // JUnit 5 equivalent of @After
    void tearDown() {
        // Clean up database (e.g., rollback transaction or truncate tables)
        // Example for Transaction Rollback Teardown:
        // transaction.rollback();
        // Example for Table Truncation Teardown:
        // executeSql("TRUNCATE TABLE users;");
    }

    @Test
    void testUserCreation() {
        // Test logic that modifies the database
    }
}
```

### 5. Security Practices

Security must be an integral part of the design and development process, not an afterthought.

**Key Points:**
*   **Security by Design:** Integrate security considerations from the initial design phase, anticipating threats and baking in defenses.
*   **Threat Modeling:** Systematically identify potential threats and vulnerabilities (e.g., using STRIDE - Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege) and prioritize mitigations.
*   **Least Privilege:** Ensure that every component or process operates with only the minimum necessary privileges to perform its function.
*   **Input Validation & Data Sanitization:** Rigorously validate all external inputs and sanitize data to prevent injection attacks (e.g., SQL Injection, Cross-Site Scripting (XSS), Cross-Site Request Forgery (CSRF)). Use domain primitives to enforce invariants and prevent invalid states.
*   **Secure Error Handling & Logging:** Avoid leaking sensitive information (passwords, credit card numbers, PII, session IDs, authorization tokens) in error messages or logs. Add sufficient context to log messages for troubleshooting, but exclude sensitive data.
*   **Confidentiality, Integrity, Availability (CIA Triad):** Design systems to protect data confidentiality (prevent unauthorized access), integrity (prevent unauthorized modification), and availability (ensure access when needed).
*   **Cryptography:** Use strong, appropriate cryptographic primitives for data protection (e.g., HTTPS for API calls, secure hashing for passwords).

**Sample Code/Configuration:**

```java
// Preventing SQL Injection (Conceptual)
// Use prepared statements or ORMs instead of string concatenation for SQL queries.
// BAD:
// String name = "Robert'); DROP TABLE Students;--";
// String sql = "INSERT INTO Students (name) VALUES ('" + name + "');";
// statement.executeUpdate(sql); // Vulnerable!

// GOOD: Use PreparedStatement (Java example)
String name = "Robert'); DROP TABLE Students;--";
String sql = "INSERT INTO Students (name) VALUES (?)";
PreparedStatement statement = connection.prepareStatement(sql);
statement.setString(1, name); // Parameters are properly escaped
statement.executeUpdate(); // Safe

// Input Validation with Domain Primitive (Quantity)
public final class Quantity {
    private final int value;

    public Quantity(final int value) {
        if (value < 0) { // Enforce non-negative quantity at creation
            throw new IllegalArgumentException("Quantity cannot be negative.");
        }
        this.value = value;
    }

    public int value() {
        return value;
    }
}

// Usage:
// BAD: Directly accepting int input for quantity
// public void setQuantity(int qty) { if (qty < 0) throw ... } // Validation can be bypassed or forgotten at calling points

// GOOD: Enforce at the type level
// New Order creation
try {
    Quantity orderQuantity = new Quantity(userInputQty); // Invalid input throws here
    Order order = new Order(orderQuantity, item);
    // ...
} catch (IllegalArgumentException e) {
    // Handle invalid quantity input
}

// Secure Logging (Conceptual)
// Avoid logging sensitive data directly.
// BAD: Directly logging sensitive information
// log.error("Transaction failed for user " + user.getUserId() + " with password " + user.getPassword());

// GOOD: Use a dedicated logging service and avoid sensitive data.
// Log with context, but without PII or credentials.
// Centralized logging service that categorizes logs (Audit, System, Error)
public interface LoggingService {
    void log(LogEntry entry);
}

public class LogEntry {
    private final String message;
    private final LogLevel level;
    private final LogCategory category; // e.g., AUDIT, SYSTEM, ERROR
    private final Map<String, String> context; // Additional non-sensitive context

    public LogEntry(String message, LogLevel level, LogCategory category, Map<String, String> context) {
        this.message = message;
        this.level = level;
        this.category = category;
        this.context = context;
    }
}

// Example usage:
// loggingService.log(new LogEntry("User login attempt", LogLevel.INFO, LogCategory.AUDIT, Map.of("userId", "user123")));
// Note: User ID is logged, but not password or other PII. For true PII, hash or anonymize before logging.

// Preventing XSS (Conceptual)
// Always escape or sanitize user-generated content before rendering it in HTML.
// BAD: Direct insertion into HTML
// String userInput = "<SCRIPT>alert('XSS')</SCRIPT>";
// String html = "<div>" + userInput + "</div>"; // Vulnerable to XSS

// GOOD: Escaping HTML output
// Using a library like OWASP Java Encoder or Apache Commons Text (StringEscapeUtils)
import org.owasp.encoder.Encode;
String userInput = "<SCRIPT>alert('XSS')</SCRIPT>";
String safeHtml = Encode.forHtml(userInput); // Escapes HTML entities
// Renders as &lt;SCRIPT&gt;alert(&#x27;XSS&#x27;)&lt;/SCRIPT&gt;
// In HTML: <div>&lt;SCRIPT&gt;alert(&#x27;XSS&#x27;)&lt;/SCRIPT&gt;</div>
// The script is displayed as text, not executed.
```

### 6. Data Management and Performance Optimization

Efficient and reliable data handling is critical for data-intensive applications. Performance must be systematically measured and optimized.

**Key Points:**
*   **Database as a Detail:** Treat the database as a low-level implementation detail, not an architectural element. The data model within the application is significant, but the specific database system is a replaceable utility.
*   **Reliability & Fault Tolerance:** Design systems to continue working correctly even in the face of hardware/software faults or human error. This includes replication strategies, partitioning, and mechanisms to handle network unreliability and clock synchronization issues in distributed systems.
*   **Performance Measurement:** Systematically measure and analyze performance (latency, CPU, memory). Use tools for benchmarking and profiling to identify bottlenecks.
*   **Resource Management:** Always ensure that resources (e.g., file handles, network connections, memory allocations) are properly closed or released to prevent leaks and unbounded waste.

**Sample Code/Configuration:**

```java
// Database as a Detail (Conceptual)
// The application interacts with a `MemberRepository` interface (as shown in Architectural Design),
// which could be implemented by a JPA, JDBC, or NoSQL specific class without changing the core logic.

// Example of Quorum Write in a Distributed System (Conceptual)
// n = number of replicas, w = number of nodes that must acknowledge write, r = number of nodes for read
// For N=3, W=2, R=2, tolerate one unavailable node
// For N=5, W=3, R=3, tolerate two unavailable nodes

// Pseudo-code for a quorum write:
// function writeData(key, value):
//     send write request to all n replicas in parallel
//     wait for w successful acknowledgements
//     if w acknowledgements received:
//         return success
//     else:
//         return failure (insufficient nodes to satisfy quorum)

// Performance Profiling (Go example)
// To capture a CPU profile for 30 seconds:
// go tool pprof -seconds 30 http://localhost:8080/debug/pprof/profile
// This downloads a profile file (.pprof).

// To open the web viewer for a profile file:
// go tool pprof -http :8080 your_cpu_profile.pprof
// This opens a web interface with various views like Graph, Top, Flame Graph.

// To view memory heap profile:
// go tool pprof -http :8080 http://localhost:8080/debug/pprof/heap

// Example of `runtime.GC()` for explicit garbage collection
package main

import (
	"fmt"
	"runtime"
	"time"
)

func main() {
	fmt.Println("Starting memory allocation...")
	b := make([]byte, 600*1024*1024) // Allocate 600 MB
	for i := range b {
		b[i] = 1 // Touch all pages to ensure allocation
	}
	fmt.Println("600 MB allocated and touched.")

	// Force garbage collection
	// Note: In real applications, avoid explicit GC calls in performance-critical paths.
	// The Go runtime manages GC automatically. This is for demonstration.
	b = nil // Dereference the slice to allow GC to reclaim memory
	runtime.GC() // Explicitly trigger GC
	fmt.Println("Forced GC completed.")

	// Allocate another, smaller slice
	fmt.Println("Allocating another 300 MB slice...")
	b = make([]byte, 300*1024*1024)
	for i := range b {
		b[i] = 2
	}
	fmt.Println("300 MB allocated and touched.")

	time.Sleep(2 * time.Second) // Keep program running to observe memory
}
```

### 7. Operational Procedures (Logging and Monitoring)

Effective logging and monitoring are crucial for understanding system behavior, troubleshooting, and ensuring operational success.

**Key Points:**
*   **Use Logging Libraries/Frameworks:** Do not implement logging manually (e.g., `printf` to file). Use standard logging libraries (e.g., Log4j, Logback for Java; Slog, Zerolog for Go) and system APIs. This ensures proper integration with system components, log rotation, and network services.
*   **Correct Log Levels:** Use appropriate log levels (TRACE, DEBUG, INFO, WARN, ERROR, FATAL) for different types of events. TRACE/DEBUG for development/troubleshooting, INFO for user/system actions, WARN for potential issues, ERROR for unexpected failures, FATAL for critical unrecoverable errors.
*   **Add Context to Messages:** Log messages must be meaningful and self-contained, providing sufficient context to understand what happened without relying on external information or previous log entries. Include recovery information if possible.
*   **Structured Logging:** Prefer structured logging (e.g., JSON, LTSV) over plain text for easier parsing, analysis, and visualization.
*   **Exclude Sensitive Data:** Absolutely do not log sensitive information like passwords, credit card numbers, or personally identifiable information (PII). This is a critical security and compliance requirement (e.g., GDPR).
*   **Avoid Vendor Lock-in:** Design your logging strategy to allow easy switching between logging libraries or frameworks, perhaps by using a facade or wrapper.
*   **Monitoring and Dashboards:** Centralize log data and visualize it using dashboards for quick insights, anomaly detection, and real-time monitoring.

**Sample Code/Configuration:**

```java
// Logging with context and proper levels (Conceptual - using a structured logger like Log4j/SLF4J + Logback)
// Assume log is an instance of a structured logger (e.g., Log4j2's Logger with JsonLayout, or similar for Go)

// BAD: Insufficient context
// log.error("Transaction failed");
// log.info("User operation succeeds");
// log.error("java.lang.IndexOutOfBoundsException"); // Don't log raw exceptions without context

// GOOD: Meaningful messages with context and appropriate levels
// Error with specific details
log.error("Transaction {transactionId} failed: {reason}", transactionId, "cc number checksum incorrect");

// Info for user actions
log.info("User {userId} successfully registered email {emailAddress}", userId, "user@domain.com");

// Debug for detailed tracing (only active in debug environments)
log.debug("Processing request for userId: {userId}, with parameters: {params}", userId, requestParams);

// Warn for unusual but not critical events
log.warn("Database call took longer than usual: {durationMs}ms for query {queryType}", duration, "SELECT_MEMBER");

// For exceptions, provide context and avoid sensitive data
try {
    // some operation
} catch (IndexOutOfBoundsException e) {
    // Log exception with specific context, avoiding sensitive data
    log.error("Array access error in {methodName}: index {index} is greater than collection size {size}",
              "processData", 12, 10, e); // Include exception object
}

// Structured Logging (LTSV example - conceptual output format)
// Output:
// timestamp:2023-10-27T10:00:00Z	level:INFO	category:AUDIT	message:User login successful	userId:user123
// timestamp:2023-10-27T10:00:05Z	level:ERROR	category:SYSTEM	message:Failed to connect to database	error:Connection refused	service:payment_gateway

// Go Logging Library Example (Conceptual using "log/slog" standard library)
package main

import (
	"log/slog"
	"os"
)

func main() {
	// Configure logger with JSON format for structured logging
	logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: slog.LevelInfo, // Default log level
	}))

	// Log an INFO message with context
	logger.Info("User registration completed",
		"user_id", "user-456",
		"email", "john.doe@example.com",
	)

	// Log an ERROR message for a simulated failure
	err := os.ErrPermission
	logger.Error("Failed to write to file",
		"file_path", "/var/log/app.log",
		"error", err, // Log the error object directly; slog handles its string representation
	)

	// Log a DEBUG message (will not appear with LevelInfo)
	logger.Debug("Detailed debug information",
		"request_id", "req-123",
		"payload_size_bytes", 1024,
	)
}

/* Example output:
{"time":"2023-10-27T10:00:00Z","level":"INFO","msg":"User registration completed","user_id":"user-456","email":"john.doe@example.com"}
{"time":"2023-10-27T10:00:05Z","level":"ERROR","msg":"Failed to write to file","file_path":"/var/log/app.log","error":"permission denied"}
*/
```