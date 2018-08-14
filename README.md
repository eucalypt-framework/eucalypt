<p align="center">
  <img width="100" src="https://s22.postimg.cc/gf1ovyb7l/eucalypt-logo.png"/>
</p>

# Eucalypt

Micro-framework and CLI for the generation and maintenance of structured Sinatra web applications.

## Installation

To install the CLI, run:

```bash
$ gem install eucalypt
```

## Usage

Initialize a new application with:

```bash
$ eucalypt init my-app
```

And you're ready to go!

## Specs

I haven't figured out a way to stub `STDIN` for testing parts of the CLI that require user input. This means the following namespaces or commands are still missing specs:

- [ ] `eucalypt blog article edit`
- [ ] `eucalypt blog article destroy`
- [ ] `eucalypt destroy`

They should work, but since they are either destructive or alter existing data, be cautious when using them.

## Notes

Still in pre-release phases!