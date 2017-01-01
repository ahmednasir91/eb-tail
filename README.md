## Tail logs of Elastic beanstalk Environment
[![Build Status](https://travis-ci.org/ahmednasir91/eb-tail.svg?branch=master)](https://travis-ci.org/ahmednasir91/eb-tail)

How hard it is to tail logs of an environment in elastic beanstalk. Now using eb-tail its very easy. eb-tail fetches all the instances of the environment and start tailing the file in all the instances, that makes it very handy.

## Example
`./eb-tail env-name`
or you can specify the file name
`./eb-tail env-name -f '/path/to/file'`

## Installation
- Clone the repository
- `bundle install`
- Make `config.yml` using the `sample.config.yml`
- `./eb-tail env-name`

And you are done!


## License

The MIT License (MIT)

Copyright (c) 2017 Ahmed Nasir

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
