# Discussion 8 - Friday, October 21<sup>st</sup>

## NFA, DFA, and Regex
### Key Differences between NFA and DFA:
- NFA can have e-transition(s) between states.
- NFA states can have multiple transitions going out of them using the same letter.

### Exercise

1. Accept using NFA

    <img src="nfa-accept.png">

2. NFA to DFA

    Convert the following NFAs to their DFAs.

    ![nfa](nfa-accept.png)

    ![nfa](nfa2.png)

3. Regex to NFA

* Go over the 3 basic operators (concatenation, union, kleene closure) and how to convert each of them to an NFA.
* Convert the following regular expressions to NFAs.
    * ab*|a*|c*
    * c(a|b)*
    * (abc)+ (equivalent to abc(abc)*)

