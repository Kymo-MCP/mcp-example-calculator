#!/usr/bin/env python3
"""
MCP Calculator Service - A comprehensive mathematical calculation toolkit for MCP clients
Provides specialized tools for addition, subtraction, multiplication, and division operations
"""
from mcp.server.fastmcp import FastMCP
from pydantic import BaseModel, Field
import sys

mcp = FastMCP("mcp-example-calculator", host="0.0.0.0", port=9001)

class AdditionRequest(BaseModel):
    num1: float = Field(..., description="First number to add (e.g., 5.5)")
    num2: float = Field(..., description="Second number to add (e.g., 3.2)")

class SubtractionRequest(BaseModel):
    num1: float = Field(..., description="Minuend - the number to subtract from (e.g., 10.5)")
    num2: float = Field(..., description="Subtrahend - the number to subtract (e.g., 4.2)")

class MultiplicationRequest(BaseModel):
    num1: float = Field(..., description="First factor to multiply (e.g., 6.5)")
    num2: float = Field(..., description="Second factor to multiply (e.g., 2.3)")

class DivisionRequest(BaseModel):
    num1: float = Field(..., description="Dividend - the number to be divided (e.g., 15.6)")
    num2: float = Field(..., description="Divisor - the number to divide by (e.g., 3.2, cannot be zero)")

@mcp.tool()
def add(request: AdditionRequest) -> str:
    """Add two numbers together
    
    Performs addition operation: num1 + num2
    
    Args:
        request: AdditionRequest with format:
                {
                    "num1": 5.5,    // First number (required)
                    "num2": 3.2     // Second number (required)
                }
        
    Returns:
        str: Addition result in format "5.5 + 3.2 = 8.7"
        
    Example usage:
        Input: {"num1": 10, "num2": 25}
        Output: "10.0 + 25.0 = 35.0"
    """
    try:
        result = request.num1 + request.num2
        return f"{request.num1} + {request.num2} = {result}"
    except Exception as e:
        return f"Addition error: {str(e)}"

@mcp.tool()
def subtract(request: SubtractionRequest) -> str:
    """Subtract one number from another
    
    Performs subtraction operation: num1 - num2
    
    Args:
        request: SubtractionRequest with format:
                {
                    "num1": 10.5,   // Minuend - number to subtract from (required)
                    "num2": 4.2     // Subtrahend - number to subtract (required)
                }
        
    Returns:
        str: Subtraction result in format "10.5 - 4.2 = 6.3"
        
    Example usage:
        Input: {"num1": 50, "num2": 18}
        Output: "50.0 - 18.0 = 32.0"
    """
    try:
        result = request.num1 - request.num2
        return f"{request.num1} - {request.num2} = {result}"
    except Exception as e:
        return f"Subtraction error: {str(e)}"

@mcp.tool()
def multiply(request: MultiplicationRequest) -> str:
    """Multiply two numbers together
    
    Performs multiplication operation: num1 * num2
    
    Args:
        request: MultiplicationRequest with format:
                {
                    "num1": 6.5,    // First factor (required)
                    "num2": 2.3     // Second factor (required)
                }
        
    Returns:
        str: Multiplication result in format "6.5 * 2.3 = 14.95"
        
    Example usage:
        Input: {"num1": 7, "num2": 8}
        Output: "7.0 * 8.0 = 56.0"
    """
    try:
        result = request.num1 * request.num2
        return f"{request.num1} * {request.num2} = {result}"
    except Exception as e:
        return f"Multiplication error: {str(e)}"

@mcp.tool()
def divide(request: DivisionRequest) -> str:
    """Divide one number by another
    
    Performs division operation: num1 / num2
    
    Args:
        request: DivisionRequest with format:
                {
                    "num1": 15.6,   // Dividend - number to be divided (required)
                    "num2": 3.2     // Divisor - number to divide by (required, cannot be zero)
                }
        
    Returns:
        str: Division result in format "15.6 / 3.2 = 4.875" or error message for division by zero
        
    Example usage:
        Input: {"num1": 100, "num2": 4}
        Output: "100.0 / 4.0 = 25.0"
        
    Error handling:
        Input: {"num1": 10, "num2": 0}
        Output: "Error: Division by zero is not allowed"
    """
    try:
        if request.num2 == 0:
            return "Error: Division by zero is not allowed"
        result = request.num1 / request.num2
        return f"{request.num1} / {request.num2} = {result}"
    except Exception as e:
        return f"Division error: {str(e)}"

def print_startup_info():
    """Print colorful startup information after server is ready"""
    GREEN = '\033[92m'
    CYAN = '\033[96m'
    BOLD = '\033[1m'
    RESET = '\033[0m'
    
    print(f"\n{GREEN}{BOLD}🚀 MCP Calculator Service is ready!{RESET}")
    print(f"{CYAN}{BOLD}📡 SSE Access Address: http://localhost:9001/sse{RESET}")
    print(f"{GREEN}✅ Service running on http://0.0.0.0:9001{RESET}\n")

def main():
    """Main entry point for the MCP calculator service"""
    try:
        print(f"Starting MCP Calculator Service on port 9001...")
        
        # Add startup callback to print info after server starts
        import threading
        import time
        
        def delayed_startup_info():
            time.sleep(2)  # Wait for server to fully start
            print_startup_info()
        
        startup_thread = threading.Thread(target=delayed_startup_info, daemon=True)
        startup_thread.start()
        
        mcp.run(transport='sse')
    except KeyboardInterrupt:
        print("\nShutting down MCP Calculator Service...")
        sys.exit(0)
    except Exception as e:
        print(f"Error starting service: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()

