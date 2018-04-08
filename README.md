## About

This is a total experiment on my side; I'm pretty sure there's some better way to achieve this. I'm 100% open to suggestions, please open an issue to discuss or better, send a PR :wink:

My problem is that I'd like to use some React components with some _legacy_ HTML/CSS, I could use Gatsby or something like that, but porting the HTML/CSS is no way an option... sometimes time is a scarce resource.

I have Googled a lot about it, but no _out of the box™_ solution, so I started playing to see where I could arrive, the worst option would be no SSR, a lot of learning and fun.

After starting to look for some inspiration, I got into this [issue](https://github.com/reactjs/react-rails/issues/634) that has the idea of some building blocks to achieve the SSR on Jekyll.

So I started trying to get things working together, my first working version was something fsckin' ugly, so after got it green, was time to refactor, and at this moment it's, at least, readable.

## How It Works

First you need some React components to use, so create your own on `webpack/components` folder, there's a `Counter` example (attention the name of the file, is the name to be used to mount the component).

Later, we need to render the component on a layout or page, as Jekyll uses liquid, I created the [ReactTag](_plugins/react_tag.rb), that is a `Liquid::Tag` where everything happens, it's responsible for:

1. Receive component name and props
1. Read the `bundle.js` file so we can execute on the server side
1. Call the `ReactRailsUJS.serverRender` function using `execjs` that returns the HTML for the rendered component.
1. Create the enclosing div (very important then the component can be mounted after loading the page) with component content

After that, when the page finished the loading process, there's a div with component content, and it's mounted by `ReactRailsUJS`, check [entry.js](webpack/entry.js) to check how it's configured.

## Example

So simple to use:

```
{% react Counter|{ name: "fernandes" } %}
```

where `Counter` is the component name (the file name, not the export/class name), and after the `|` (pipe), the props are in the Ruby Hash format.

## Get it Up and Running

Install dependencies your way, mine is:

* bundle install
* yarn (be sure you have node installed, duh :stuck_out_tongue_winking_eye:)

Run commands, run webpack to generate bundle.js before jekyll

* yarn run webpack -w
* jekyll server

Access your [jekyll site](http://localhost:4000)

## Deploying

```bash
yarn run webpack.js # to generate your bundle.js file
jekyll build # generate `_site` folder
```

After that you just need to push `_site` folder to gh-pages branch.

How to do this? I just create an orphaned branch with the folder content, commit and push, you can check the [gh-pages branch](https://github.com/fernandes/jekyll-webpack-ssr/tree/gh-pages)

Wanna see it working? Check the [demo](http://www.coding.com.br/jekyll-webpack-ssr/)

## Next Steps

- [ ] I'm considering creating a plugin for Jekyll so anyone can use it easily (not sure about the webpack stuff)
- [ ] If someone already has a webpack working, how to specify the `bundle.js` path? Jekyll config?
- [ ] Better error handling, at this moment I hope everything is going to work flawlessly
- [ ] Add support for hot reload on this boilerplate

## Contributing

Open an issue, send PR, give any idea, suggestion, you're welcome! :smile:

## Thanks

* [Robert Mosolgo](https://github.com/rmosolgo) for the reply on the issue
* [react-rails](https://github.com/reactjs/react-rails) developers, special thanks for lending the [React::ServerRendering::ExecJSRenderer](https://github.com/reactjs/react-rails/blob/21ae89b427d4b765c3f2c7db035006bff0569bee/lib/react/server_rendering/exec_js_renderer.rb) class and ReactRailsUJS :blush:
* [execjs](https://github.com/rails/execjs) developers, made my life easier doing SSR
