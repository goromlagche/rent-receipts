# rent-receipts

## What?

A small ruby script which generates rent recipts.

## Why?

There are lots of online rent recipt generator available.
Here are the issues
1. Most of them require email-id
2. Water-mark

## How to run

First, you will need to fill out the details in a params.env file, [sample](https://github.com/goromlagche/rent-receipts/blob/master/params.env)

Then,
```
docker run -it -d  --env-file params.env  -v ${PWD}:/rents goromlagche/rent-receipts:0.1
open rent.pdf
```

## Ugly parts

**Fonts.**

I am not very familiar with designing things.
