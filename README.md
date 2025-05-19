# README

This service is designed to route orders for glasses to the relevant production partners.

It uses a predefined set of business rules along with the stock information about each type of glasses.

Tech Stack:

* Ruby version v3.4.4
* Ruby on Rails v8.0.2
* RSpec
* Rubocop

Clone from Github

```
git clone https://github.com/nitika080289/aceandtateassignment.git
cd AceandTateAssignment
```

Install dependencies:

```
bundle install
```
How to run:

* Using Docker:
```
docker build -t ace_and_tate_assignment
docker run -p 3000:3000 ace_and_tate_assignment
```

* Without Docker:
```
rails server
```

How to run tests:
```
bundle exec rspec
```
Lint Check:
```
bundle exec rubocop
```

API Usage:

* POST

URL: http://localhost:3000/api/routeOrder

Method: POST

Sample Payload: 
```
{
    "id": 2020020001,
    "shipping_country": "DE",
    "lines": [{
        "sku": "metal-frame-1",
        "quantity": 1,
        "prescription": {
            "type": "multifocal",
            "lens_color": null,
            "left": {
                "SPH": -1
            },
            "right": {
                "SPH": -1.25
            }
        }
    }]
}
```

Sample Response:
```
{
    "routing_result": "LETHA"
}
```

Stock json path: 
```
spec/support/stock/stock_overview.json
```

Github Workflows:

* CI workflow

    Runs tests(rspec) and lint check(rubocop)

