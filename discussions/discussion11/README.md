# Discussion 11 - Friday, December 2<sup>nd</sup>

## What is Rust? 



Modern language designed for concurrency; it's similar to C++ and OCaml, but does it in a fast + safe manner
* How does it achieve speed and safety? It avoids Garbage Collection, and instead uses rules for memory management 

	`let mut x = String::from("hello");` &lt;- Mutability

	`do_something(&mut x);` &lt;- Borrowing, avoids ownership change

	`println("{}",x);`



There's three concepts that we need to keep in mind when developing in Rust: Mutability, Ownership, and Borrowing
* _Mutability:_ Variables can either be declared as mutable (`mut`) or immutable
    * Similar to `const` in C
    * Mutable means the variable can be reassigned, e.g. `let mut x = 0; x = 5;`
* _Ownership:_ Technique used to automatically free variables
    * Essentially, each piece of data has one owner, and when the owner goes out of scope, the variable is removed
    * Note that this only matters for non-primitives, as primitives like integers, booleans, etc. implement the `Copy` trait, so their value can simply be copied to new variables
    * E.g. 
    
    	`let s1 = String::from("hello")` &lt;- s1 is owner
    
    	`let s2 = s1;` &lt;- Now s2 is owner, s1 goes out of scope
    
    	`println!("{}",s1)` &lt;- Not allowed, as s2 is out of scope
    
    * Ownership changes through two operations
        * Variable aliasing
            * `let s1 = String::from("hello"); s2 = s1`
            * Now s2 is owner of the String, s1 is out of scope
        * Function call
            * When function is passed in a variable, ownership is transferred to the function, and goes out of scope after function is run
            * `let s1 = String::from("hello"); do_something(s1);`
            * s1 is now out of scope
* _Borrowing/References_
    * We can use references to get around ownership issues
    * Borrowing is similar to points in C, two types
        * Mutable ref, `&mut` - Can edit variable
        * Immutable ref, `&` - Can't edit
    * Allows us to pass in references to functions, preventing ownership from going out of scope
    * Also used for things like iteration; when looping through list, get a series of references to elements in list
    * One limitation: Can only either have 1 mutable ref or many immutable refs
        * This prevents weird write errors
    * Exemplified by String class; `&str` is a read-only pointer to String, whereas String class is similar to array of chars

Example with .iter(): 

```ocaml
let mut arr = [1,2,3];
for &i in arr.iter() {
	println!("{}",i);
}
```

What does this mean when you write programs? 



1. Make sure you know which variables are mutable and immutable
2. Be aware of who owns certain variables, and pass around references to make sure ownership doesn't go out

Some common errors are



1. Variable mutability
2. Using variable after it goes out of scope
3. Passing in regular variable instead of reference
4. Failing to return correct value from function
5. Incorrect types (reference when regular variables should be used, etc.)

## Debugging Problems 

Each of the functions in error.rs has an error; fix the error

Solutions in correct.rs

