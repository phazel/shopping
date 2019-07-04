# Checkout module

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
If the SKU passed into the `scan` method isn't recognised, a `SKUError` will be raised. The entire checkout process will be stopped.

## Assumptions

- The rules should be applied in the order that they're given.
- This code is to be used as a module within a larger codebase, rather than deployed independently.
- The class has access to pricing information stored somewhere else, most likely a database. This is represented with a hash constant, however this doesn't reflect the most likely scenario. The tests also depend on this information, which isn't ideal, however with the given API requirements it's not possible to pass the pricing information into the Checkout class, which would provide a much more self-contained module.
- Ratio rules will only ever give one item free for each number. eg. (4 for the price of 3, 3 for the price of 2). This could be altered if the need arose.
- The Bundle rule won't automatically add the bundled item, in case the customer doesn't want one.
- There is no need to record or display which discount rules have been applied to which items. This means that multiple rules might be applied to the same item.
- The system using with this class will find working with Ruby symbols as hash keys more convenient. If not, then to avoid boilerplate conversion code we could use strings instead just as well.
- It's possible to interpret the first and third rules as being different instances of a more generic type of Ratio rule. However, given that the rules are unpredictable and subject to change, it's better to keep them highly specific and add any new types of rules that might come along, rather than try to genericise.
