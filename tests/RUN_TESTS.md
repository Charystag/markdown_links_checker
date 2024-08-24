# Run Tests

# How to run the test suite ?

To run the test suite, you have to `cd` into the `tests` directory 
and run the `run_tests.sh` script from there. This script takes 
a file filed of tests as an argument.


## What are the contents of this file ?

On each row you can see two fields that are separated by a tab 
character. (You can view the non-printable characters on vim by 
running `:set list`, which you can turn off with `:set nolist`)

The first field represent the end of a command which starts with 
`bash ../check_links.sh` which is why you have to cd in the directory 
first. It is the test to run.

The second field is the expected output file which has been generated 
either by hand or with a validated and working version of the script. 

Those two fields are to update as this script evolves.

## What does this script outputs ?

For now, it only ouputs a result of the test suite run. It also returns 
0 or 1 based on whether or not all the tests where successful
