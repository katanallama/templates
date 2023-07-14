package com.projectName;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

class ProjectTest {

    @Test
    void testProjectOutput() {
        // Redirect standard output to a ByteArrayOutputStream
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PrintStream originalOut = System.out;
        System.setOut(new PrintStream(outputStream));

        // Call the main method of Project class
        Project.main(new String[]{});

        // Restore original standard output
        System.setOut(originalOut);

        // Get the console output
        String consoleOutput = outputStream.toString().trim();

        // Define the expected output
        String expectedOutput = "Hello, World!";

        // Assert that the console output matches the expected output
        assertEquals(expectedOutput, consoleOutput);
    }

    // TODO add more tests
}
