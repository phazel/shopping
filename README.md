# Shopping class

## Setup

- Install Ruby 2.6.3
- `gem install bundler`
-  Tests: `bundle exec rspec`

## API

```ruby
  co = Checkout.new(pricingRules)
  co.scan(item1)
  co.scan(item2)
  co.total()
```

`item1` is a symbol which represents a SKU for a product.

### Errors

###### SKUError
If the SKU passed into the `scan` method isn't recognised, a `SKUError` will be returned.

## Assumptions

- The rules should be applied in the order that they're given.
- This code is to be used as a module within a larger codebase, rather than deployed independently.
- Ratio rules will only ever give one item free for each number. eg. (4 for the price of 3, 3 for the price of 2). This could be altered if the need arose.
- There is no need to record or display which discount rules have been applied to which items.
