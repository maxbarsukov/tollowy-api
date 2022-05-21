## wrong number of arguments (given 2, expected 0)

Check your code for using `RSpec` `DSL` methods in `let`:

- `let!(:post)` => `let!(:my_post)`:
  `post` DSL method is being called by rspec, when it's trying to memoize `let!(:post)`, hence why you get the argument error.
     The rswag post takes 2 arguments (a summary, and a block)
