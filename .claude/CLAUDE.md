# Coding Agent Custom Instructions: Comprehensive Development Guide

This document outlines essential principles and practices for software development, covering domain modeling, architecture, coding standards, testing, security, and operational concerns. Adherence to these guidelines is paramount for delivering high-quality, reliable, and secure software.

## 1. Domain Modeling and Core Concepts

### 1.1 Always-Valid Domain Model
**Instruction:** Design domain objects so that they can only be created and exist in a valid state. Encapsulate all validation logic within constructors or factory methods, preventing the instantiation of objects with illegal or inconsistent attributes. Use distinct types to represent different valid states or business rules, thereby eliminating "loose types" and "implicit relationships between multiple attributes."

**Sample Code:**
```java
// Prevent invalid email addresses from being created
public class Member {
    private String emailAddress;

    public Member(String emailAddress) {
        if (!emailAddress.matches("^\\S+@\\S+\\.\\S+$")) {
            throw new IllegalArgumentException("Invalid email format.");
        }
        this.emailAddress = emailAddress;
    }
}

// Represent verified and unverified states with distinct types
public abstract class EmailAddress {
    protected String value;
    // Common behavior or properties
}

public class VerifiedEmailAddress extends EmailAddress { /* ... */ }

public class UnverifiedEmailAddress extends EmailAddress { /* ... */ }

public interface VerifyEmailService {
    // This method can only take an UnverifiedEmailAddress and returns a VerifiedEmailAddress
    VerifiedEmailAddress verify(UnverifiedEmailAddress emailAddress);
}
```

### 1.2 Domain Primitives / Value Objects
**Instruction:** Model characteristics or attributes that lack conceptual identity as Value Objects. Value Objects should be immutable, represent a conceptual whole, and define equality based on their attribute values rather than object identity. They should enforce their invariants upon creation.

**Sample Code:**
```java
// Example of a Value Object for Quantity, enforcing non-negative values
public final class Quantity {
    private final int value;

    public Quantity(int value) {
        if (value < 0) {
            throw new IllegalArgumentException("Quantity cannot be negative.");
        }
        this.value = value;
    }

    // Implement equals() and hashCode() based on value
    @Override
    public boolean equals(Object o) { /* ... */ }

    @Override
    public int hashCode() { /* ... */ }
}
```

### 1.3 Entities and Aggregates
**Instruction:** Identify objects by their durable identity rather than their attributes (Entities). Group closely related Entities and Value Objects into Aggregates, treating them as a single transactional unit. Ensure that all invariants for the Aggregate are maintained within its boundary, typically by controlling access to internal entities through the Aggregate Root.

**Sample Code:**
```java
// Aggregate Root: Loan
public class Loan {
    private String loanId; // Entity identity
    private SharePie shares; // Value Object within the Aggregate

    public Loan(String loanId, SharePie initialShares) {
        this.loanId = loanId;
        this.shares = initialShares;
    }

    // Method to apply principal payment, ensuring invariant is maintained internally
    public void applyPrincipalPayment(Map<Object, Double> paymentShares) {
        this.shares = this.shares.decrease(new SharePie(paymentShares));
        // ...
    }
}
```

### 1.4 Design with Types (Algebraic Data Types)
**Instruction:** Leverage the type system to express domain concepts, constraints, and business logic explicitly. This "Type-First Development" approach enables early feedback and improves clarity. For optional values or potential failures, use union types (e.g., `Option`, `Either`, `Result`) rather than null or sentinel values.

**Sample Code:**
```fsharp
// F# example: Using a choice type to represent an operation's result
type TransferResult =
    | Success of string
    | InsufficientFunds of string
    | AccountNotFound of string
```
```java
// Equivalent concept in Java (simplified)
public interface Result<T, E> {
    static <T, E> Result<T, E> success(T value) { /* ... */ }
    static <T, E> Result<T, E> failure(E error) { /* ... */ }
    // ...
}

// Usage in an Account class
public Result<String, String> transfer(Amount amount, Account toAccount) {
    if (this.balance.isLessThan(amount)) {
        return Result.failure("INSUFFICIENT_FUNDS");
    }
    // ... execute actual transfer ...
    return Result.success("Transfer successful");
}
```

## 2. Architecture and Design Principles

### 2.1 Clean Architecture & Layering
**Instruction:** Architect applications by separating concerns into distinct, concentric layers (e.g., Entities, Use Cases, Controllers, Frameworks). Dependencies should always point inwards, meaning inner layers are oblivious to outer layers. Databases and web frameworks are considered "details" that should not dictate the core domain logic.

**Sample Code (Conceptual Layer Separation):**
```java
// Domain Layer (Core business logic)
public interface MemberRepository {
    void save(Member member);
    Member findById(String id);
}

// Application Layer (Orchestrates use cases)
public class RegisterMemberUseCase {
    private final MemberRepository memberRepository;

    public RegisterMemberUseCase(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    public void execute(RegisterMemberCommand command) {
        Member newMember = new Member(command.getEmailAddress());
        memberRepository.save(newMember);
    }
}

// Infrastructure Layer (Frameworks, DB, etc. - implementation details)
public class JpaMemberRepository implements MemberRepository {
    // @PersistenceContext private EntityManager em; // JPA-specific detail
    @Override
    public void save(Member member) { /* em.persist(member); */ }

    @Override
    public Member findById(String id) { /* return em.find(...); */ return new Member("test@example.com"); }
}
```

### 2.2 Dependency Injection (DI) & Inversion of Control (IoC)
**Instruction:** Employ Dependency Injection to manage object dependencies. Instead of components creating their own dependencies, they should be provided (e.g., via constructor injection). This fosters loose coupling, enhances testability, and allows for flexible configuration.

**Sample Code:**
```java
// With DI (loosely coupled via constructor injection)
public interface DataRepository { String getData(); }
public class DataRepositoryImpl implements DataRepository { /* ... */ }

public class DataService {
    private final DataRepository repository; // Dependency is injected

    public DataService(DataRepository repository) { // Constructor injection
        this.repository = repository;
    }
    public void performAction() { /* ... */ }
}

// Configuration
public class ApplicationConfig {
    public static void main(String[] args) {
        DataRepository repository = new DataRepositoryImpl();
        DataService service = new DataService(repository);
        service.performAction();
    }
}
```

### 2.3 Microservices
**Instruction:** When designing microservices, aim for strong decoupling and independent deployability. Each service should enforce its own invariants. Design service APIs to explicitly represent business operations and their boundaries, not just data models.

### 2.4 RESTful Design
**Instruction:** Adhere to REST principles for web-based interactions. Utilize standard HTTP methods (GET, POST, PUT, DELETE) semantically. Understand that GET, PUT, and DELETE are idempotent, meaning they can be safely called multiple times without additional side effects.

**Sample Code (Spring Boot REST Controller):**
```java
@RestController
@RequestMapping("/api/products")
public class ProductController {
    private final ProductService productService;
    // ... Constructor

    @GetMapping("/{id}") // GET is idempotent and safe
    public ResponseEntity<ProductDto> getProduct(@PathVariable String id) { /* ... */ }

    @PostMapping // POST is typically NOT idempotent (creates new resource)
    public ResponseEntity<ProductDto> createProduct(@RequestBody ProductDto productDto) { /* ... */ }

    @PutMapping("/{id}") // PUT is idempotent (replaces/updates resource)
    public ResponseEntity<ProductDto> updateProduct(@PathVariable String id, @RequestBody ProductDto productDto) { /* ... */ }

    @DeleteMapping("/{id}") // DELETE is idempotent
    public ResponseEntity<Void> deleteProduct(@PathVariable String id) { /* ... */ }
}
```

### 2.5 Design Patterns
**Instruction:** Apply well-established design patterns to address recurring problems and improve the structure, flexibility, and maintainability of code. Examples include the Decorator pattern for adding responsibilities dynamically and the Factory pattern for complex object creation.

## 3. Code Quality and Practices

### 3.1 Clean Code and Naming
**Instruction:** Prioritize writing code that is clean, readable, and easy to understand. All identifiers (files, modules, functions, variables, classes) must have specific, descriptive names that accurately reflect their purpose. The use of vague names like `common`, `util`, `helper`, `data`, or `manager` is strictly prohibited. These are anti-patterns that lead to low cohesion and high coupling. For example, instead of `util.py`, create `user_credential_formatter.py`.

**Sample Code (Refactoring for Clarity):**
```java
// Original code (less clear error handling)
private void startSendingOld() {
    try {
        doSending();
    } catch (SocketException e) {
        // normal. someone stopped the request.
    } catch (Exception e) {
        try {
            response.add(ErrorResponder.makeExceptionString(e));
            response.closeAll();
        } catch (Exception e1) { /*Give me a break!*/ }
    }
}

// Refactored code (clearer error handling and responsibility)
private void startSending() {
    try {
        doSending();
    } catch (SocketException e) {
        // Normal: Client stopped the request. Log at DEBUG/INFO.
        logger.debug("SocketException during sending, likely client disconnect", e);
    } catch (Exception e) {
        handleSendingException(e);
    }
}

private void handleSendingException(Exception e) {
    try {
        // ... create error response and close connection ...
    } catch (Exception closeException) {
        logger.error("Failed to handle exception or close connection", closeException);
    }
}
```

### 3.2 Error Handling (Exceptions vs. Result Objects)
**Instruction:** Distinguish between truly exceptional conditions (for which exceptions are appropriate) and expected, though undesirable, outcomes (which should be modeled using return values like `Result` types). Avoid returning `null`.

**Sample Code (Result Object for Business Logic Errors):**
```java
public enum TransferFailureReason { INSUFFICIENT_FUNDS, ACCOUNT_LOCKED }

public class MonetaryTransferResult {
    // ... success, failureReason, message ...
    public static MonetaryTransferResult success(String message) { /* ... */ }
    public static MonetaryTransferResult failure(TransferFailureReason reason, String message) { /* ... */ }
    // ... isSuccess(), etc.
}

public class BankAccount {
    public MonetaryTransferResult transfer(double amount, BankAccount recipient) {
        if (this.balance < amount) {
            return MonetaryTransferResult.failure(TransferFailureReason.INSUFFICIENT_FUNDS, "Not enough funds.");
        }
        // ... perform transfer ...
        return MonetaryTransferResult.success("Transfer completed.");
    }
}
```

### 3.3 Pragmatic Documentation
**Instruction:** Documentation must illuminate the "why," not the "what." Focus on explaining complex logic or crucial design decisions that cannot be inferred from reading the code. The creation of redundant documentation (e.g., comments that paraphrase the code, docstrings for obvious methods) is strictly forbidden. The code is the primary source of truth.

**Sample Code:**
```java
// Bad Comment: Explains the "what", not the "why"
// Increments the counter by one.
i++;

// Good Comment: Explains the "why" or provides critical context
// We must flush the buffer here to ensure the data is sent before closing the connection,
// otherwise a race condition can occur on the client side.
writer.flush();
```

### 3.4 Formatting
**Instruction:** Maintain a consistent and clean code formatting style throughout the project, including indentation, whitespace, and brace placement. This enhances readability and maintainability.

## 4. Testing and Verification

### 4.1 Core Testing Principles
**Directive:** All testing activities are governed by these principles:
* **Tests as Immutable Specifications:** Treat test suites as the executable specification of behavior. The implementation must change to meet the test's requirements, not the other way around.
* **Mandated Process for Test Modification:** Only modify test code if explicitly assigned, if it has a syntax error, or if it is logically self-contradictory. In the latter cases, halt and request permission before modifying.
* **Data-Agnostic Implementation:** Implementation logic must be entirely agnostic to specific test data values (e.g., no `if user_id == "test-user-123"`).

### 4.2 Test-Driven Development (TDD)
**Instruction:** When a task requires TDD, follow a strict "Red-Green-Refactor" sequence.
1.  **RED:** Write a complete, atomic test that fails.
2.  **VALIDATION GATE:** Present the test code to the user for review and approval before proceeding.
3.  **GREEN:** Write the minimum amount of implementation code to make the test pass.
4.  **REFACTOR:** Improve the code's design while keeping all tests green.

**Sample Code (TDD Cycle Example):**
```java
// 1. RED: Write a failing test
@Test
void calculator_shouldReturnSum_forTwoPositiveIntegers() {
    Calculator calculator = new Calculator();
    assertEquals(5, calculator.add(2, 3)); // Fails, add() doesn't exist yet
}

// 2. GREEN: Write minimal code to pass
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
}

// 3. REFACTOR: (Example) If logic becomes complex, refactor it
// In this simple case, no refactoring is needed. The code is clean.
```

### 4.3 Unit Testing
**Instruction:** Write unit tests that verify small, isolated units of behavior. Tests should be fast, reliable, and isolated from external dependencies. Use descriptive names that articulate the scenario and expected outcome.

**Sample Code (Unit Test Naming):**
```java
@Test
void delivery_withAPastDate_isInvalid() {
    DeliveryDateValidator validator = new DeliveryDateValidator();
    assertThrows(IllegalArgumentException.class, () -> validator.validate(LocalDate.now().minusDays(1)));
}
```

### 4.4 Integration Testing
**Instruction:** Conduct integration tests to verify interactions between different components or layers, especially those involving external dependencies like databases or external APIs. Prioritize testing the "happy path" and critical edge cases.

### 4.5 Test Doubles (Stubs, Spies, Mocks)
**Instruction:** Use Test Doubles (Stubs, Spies, Mocks) to isolate the system under test (SUT) from its dependencies, especially for hard-to-test components (e.g., I/O, external services, time).

**Sample Code (Test Stub for Time):**
```java
public interface TimeProvider { LocalDateTime getCurrentTime(); }

// Test Stub: Provides a controlled, predictable time for testing
public class FixedTimeProvider implements TimeProvider {
    private final LocalDateTime fixedTime;
    public FixedTimeProvider(LocalDateTime fixedTime) { this.fixedTime = fixedTime; }
    @Override public LocalDateTime getCurrentTime() { return fixedTime; }
}

@Test
void shouldFormatTimeCorrectlyAtMidnight() {
    TimeProvider stubTimeProvider = new FixedTimeProvider(LocalDateTime.of(2023, 1, 1, 0, 0));
    TimeDisplayFormatter formatter = new TimeDisplayFormatter(stubTimeProvider);
    assertEquals("Current time: 00:00", formatter.formatCurrentTime());
}
```

### 4.6 Parameterized Tests
**Instruction:** Use parameterized tests to run the same test logic with different input data. This reduces test code duplication and makes it easier to add new test cases.

**Sample Code (JUnit 5):**
```java
@ParameterizedTest
@CsvSource({ "1, 1, 2", "2, 3, 5", "10, -5, 5" })
void addition_shouldReturnCorrectSum(int a, int b, int expectedSum) {
    Calculator calculator = new Calculator();
    assertEquals(expectedSum, calculator.add(a, b));
}
```

## 5. Security and Reliability

### 5.1 Threat Modeling
**Instruction:** Integrate threat modeling into the design process. Systematically identify potential threats (e.g., using STRIDE: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege), vulnerabilities, and mitigations.

### 5.2 Principle of Least Privilege
**Instruction:** Design every component to operate with the minimum privileges required to perform its function. This reduces the blast radius if a component is compromised.

### 5.3 Secure Failure Handling
**Instruction:** Design systems to fail fast and securely, preventing sensitive data exposure during error conditions. Implement patterns like Circuit Breakers to prevent cascading failures and define explicit timeouts for all external calls.

### 5.4 Input Validation & Sanitization
**Instruction:** Implement strict validation and sanitization for all external inputs. Do not trust data from clients or external systems. Use domain primitives to enforce data correctness at the type level.

**Sample Code (Domain Primitive for Validation):**
```java
public final class ProductCode {
    private final String value;
    public ProductCode(String rawValue) {
        if (rawValue == null || !rawValue.matches("^[A-Z0-9]{5,10}$")) {
            throw new IllegalArgumentException("Invalid product code format.");
        }
        this.value = rawValue;
    }
    public String getValue() { return value; }
}
```

### 5.5 Sensitive Data Handling
**Instruction:** Strictly prohibit logging, displaying, or storing sensitive information (passwords, PII) in plain text. Implement "read-once" objects or redaction to prevent accidental exposure in logs, error messages, and UI.

**Sample Code (Simplified Read-Once Password):**
```java
public final class Password {
    private final char[] value;
    private boolean consumed = false;

    public Password(char[] value) { this.value = value.clone(); }

    public synchronized char[] getValueAndConsume() {
        if (consumed) throw new IllegalStateException("Password already consumed.");
        consumed = true;
        char[] temp = value.clone();
        Arrays.fill(value, '0'); // Clear internal state
        return temp;
    }

    @Override
    public String toString() {
        return "********"; // Never expose in logs
    }
}
```

## 6. Operational Concerns and Performance

### 6.1 Logging Best Practices
**Instruction:** Use a structured logging library (e.g., SLF4J, Slog). Use appropriate log levels (DEBUG, INFO, WARN, ERROR) to categorize messages. Add sufficient context (e.g., user ID, request ID) to make messages meaningful for troubleshooting. Never log sensitive data.

**Sample Code (Structured Logging):**
```go
// Using Go's slog library
logger.Info("Attempting to process order",
    slog.String("order_id", orderID),
    slog.String("user_id", userID),
)
```

### 6.2 Performance Optimization
**Instruction:** Approach performance optimization with a data-driven mindset. Use profiling to identify bottlenecks and benchmarking to measure improvements. Understand resource usage (CPU, memory, I/O).

**Sample Command (Go pprof for CPU profiling):**
```bash
# 1. Run app with profiling enabled
go run main.go --cpuprofile=cpu.pprof

# 2. Analyze the profile
go tool pprof -http=:8080 cpu.pprof
```

### 6.3 Resource Management
**Instruction:** Always ensure that resources like file handles, network connections, and database connections are properly closed or released after use to prevent leaks and system instability.

**Sample Code (Resource Management):**
```java
// Java: Using try-with-resources for automatic closing
try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
    // ... read from file ...
} catch (IOException e) {
    // ... handle error ...
}
```
```go
// Go: Using `defer` for resource cleanup
file, err := os.Create(filename)
if err != nil { return err; }
defer file.Close() // Ensures file is closed when the function exits

// ... write to file ...
```
