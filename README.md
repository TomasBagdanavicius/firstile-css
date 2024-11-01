# Firstile CSS

Firstile CSS is a modular, Sass-based CSS framework and starter kit that provides a structured approach to building CSS stylesheets. This project is built around a robust system of components, each categorizing a specific set of HTML elements. These components include normalization, base, style collections, and modules, enabling you to apply consistent, modular styling. Moreover, they ensure that only the relevant custom variables are included in the root context, optimizing your stylesheet and maintaining a clean, efficient codebase. Firstile CSS is perfect when you want to create a bunch of optimal CSS files each requiring specific styling goals.

Imagine you're building a web project where you only need specific styles and components. Instead of loading an entire stylesheet with a full list of custom variables, normalization tasks for all elements, unnecessary rules, you can use this streamlined approach:

```scss
@use "../../src/partials/layer-list" with (
    $layer-list: "root, normalize, base",
);
@use "../../src/components/hyperlink/base" as hyperlink-component;
@use "../../src/components/list/base" as list-component;
@use "../../src/partials/root";
@include root.printProps();
```
Which will generate something like this (*compact format is for demonstration purposes only; further optimization can be performed using minifiers*):
```css
@layer root, normalize, base;
/* Base */
@layer normalize {
  ul, ol, menu { margin: 0; padding: 0 }
  ul, ol, menu { list-style: none }
  :focus-visible { outline: none }
  *, ::before, ::after { box-sizing: border-box }
}
/* Hyperlink */
@layer normalize {
  a:any-link { color: inherit; text-decoration: none }
}
/* Base */
@layer base {
  :focus, :focus-visible { outline: solid 2px var(--accent-color); outline-offset: 1px }
  .clickable { cursor: pointer }
  .group { display: flex; flex-direction: column; flex-wrap: wrap }
}
/* Hyperlink */
@layer base {
  a:any-link { color: var(--hyperlink-color) }
  @media (hover: hover) {
    a:any-link:hover { color: var(--hyperlink-color-active) }
  }
  a:visited { color: var(--hyperlink-color-active) }
}
/* List */
@layer normalize {
  dl, dd { margin: 0 }
}
/* Root Properties */
@layer root {
  :root { color-scheme: light dark; --hyperlink-color: var(--accent-color); --hyperlink-color-active: var(--accent-color-active); --list-item-indent: 30px }
  :root[data-theme=dark] { color-scheme: dark; --theme-binary: 0; --contrast: #000; --opposite-contrast: #fff }
  :root[data-theme=light] { color-scheme: light; --theme-binary: 1; --contrast: #fff; --opposite-contrast: #000 }
}
```

## Components Overview

Firstile CSS is organized into 18 components, each categorizing a specific set of HTML elements to streamline your styling process. These components offer comprehensive styling by including specialized normalization, base, and style collections, as well as optional module styles.

Normalization resets default browser styles, ensuring consistency across different environments. Base collections provide fundamental styling that builds upon the normalization to create a solid foundation. Style collections then offer advanced, component-specific styling options, which can be extended or customized as needed. Modules within certain components allow for further granular control, adding additional styling capabilities specific to various use cases.

For a detailed list of all components and their associated elements, see the full map in [`./docs/component-elements.md`](docs/component-elements.md). Additionally, the [`./demo`](demo) directory mirrors this organization, showcasing the styles for each component in a structured and practical manner.

## Quick Start & Demo

### Utilising Your Own HTTP Server

If you have your own HTTP server, the simplest way is to just copy all project files into a desired location inside your document root directory and then run it in your browser.

### Using Docker

- Make sure you have [Docker](https://docs.docker.com/get-docker/) installed and running on your system.
- Create a Docker image by running `docker build -t firstile .` inside the project directory.
- Run and map the port `docker run -p 8082:8082 -d firstile`.
    - You can customize the port by amending the host port, eg. `docker run -p [custom_host_port]:8082 -d firstile`.
- Navigate to http://localhost:8082 in your browser. If you chose a custom port, make sure to change it in the URL.
- To stop Docker container, run `docker stop [container_id]`. Docker must have printed your container ID into the console after you ran the docker container. Alternatively, you can run `docker ps` to get a list of running containers.

> **Note:** If you are using VS Code code editor, you have the option to run Terminal tasks "Build and run with Docker" and "Stop Docker container". Navigate to `Terminal` -> `Run Task...`.

### Running Demo Slides

Once you have your HTTP server running, the best way to familiarize with all demonstration files is to navigate to `/demo/slides.html` (relative path) in your browser.

## Creating & Compiling Your Custom Sass Files

### Install Developer Dependencies

To compile Sass files and to clean up and minify the resulting CSS, you will need a few developer dependencies.

- Make sure you have [Node.js](https://nodejs.org/en/download/package-manager) installed.
- Inside the project directory run `npm install` to install all developer dependencies. This will create the `/node_modules` directory and the `package-lock.json` file.

### Create Custom Sass File

- Create your custom `.scss` file inside [`./var/stylesheets`](var/stylesheets). You can use [`./var/stylesheets/_template.scss`](var/stylesheets/_template.scss) as a template file for your custom `.scss` file.
- Normally, your file should start with a list of layers that will be used throughout the file, for example:
```scss
@use "../../src/partials/layer-list" with (
    $layer-list: "root, normalize, base",
);
```
- Afterwards, you will include other component files (eg. base styles, style collections, modules, etc.).
```scss
// Base styles from the "document-context" component
@use "../../src/components/document-context/base" as document-context;
// Base styles from the "button" component
@use "../../src/components/button/base" as button;
// Base styles from the "list" component
@use "../../src/components/list/base" as list;
// Style collection from the "list" component
@use "../../src/components/list/styles" as list-styles;
// Style collection from the "grid" module
@use "../../src/components/structural-content/modules/grid/styles" as grid-styles;
```
- As you include various files from components, the system will collect a list of relevant custom properties that should be used in the root context. To print them, you need to add:
```scss
@use "../../src/partials/root";
@include root.printProps();
```
- The following code will compile into something similar to [`./docs/examples/example.css`](docs/examples/example.css). The `:root` declaration block under the "root" layer will host only relevant custom variables from the components that are actually used in the file.

> **Note:** If you are building a CSS file for a custom element, you can replace `:root` selector and optionally exclude default custom properties by using:
```scss
@include root.printProps(":host", $include-default: false);
```

### Use Custom Properties for a Given Component

If you want to add or modify custom properties that would be included into the root context for a specific component, you can make use of the [`./var/custom-properties.scss`](var/custom-properties.scss). For example:
```scss
$custom-properties: (
    button: (
        // Amending existing custom property
        --button-border-radius: 5px,
        // Adding new custom property
        --button-font-size: 14px,
    ),
);
```

### Use Custom Properties for a Given Module

Similarly, you can add or modify custom properties for a given module. This can be achieved through the [`./var/custom-module-options.scss`](var/custom-module-options.scss) file. For example:
```scss
$module-options: (
    structural-content: (
        website-container: (
            // Amending existing custom property
            --website-container-gutter: 20px,
        ),
    ),
);
```

### Compiling All Custom Sass Files

Inside the project directory run `node ./scripts/compile-stylesheets.js`. This will compile all files from [`./var/stylesheets`](var/stylesheets) into [`./dist`](dist).

This process will create 3 CSS files for each Sass file: (1) the main uncompressed file, (2) minified file, (2) and a map file that links compiled CSS back to its original Sass source.

The `./scripts/compile-stylesheets.js` script has a few option parameters:

- `removeEmptyLayers=0|1` (Default: 1) - whether to exclude `@layer` at-rules that do not have any contents from the minified CSS file , eg. `node ./scripts/compile-stylesheets.js removeEmptyLayers=0`.
- `removeUnusedLayers=0|1` (Default: 1) - whether to amend the list of layers at the top of the minified CSS file to include only those layers that are actually defined in the file, eg. `node ./scripts/compile-stylesheets.js removeUnusedLayers=0`.
- `sourceMap=0|1` (Default: 1) - whether to build the source map, eg. `node ./scripts/compile-stylesheets.js sourceMap=0`.

## Creating Custom Components and Modules

There might be scenarios where you want to create your custom components (eg. to categorize your custom elements) or custom modules (eg. to extend granural control of existing components).

To create a custom component:

- Duplicate the [`./var/components/_template`](/var/components/_template) directory.
- Amend the `base.scss`, `normalize.scss`, and `props.scss` files to your liking.
  - Make sure to define your component name inside the `apply-user-properties` mixin in the `props.scss` file.
- Inside the custom component directory you can also create a "demo" directory. By running `./scripts/compile-demo-stylesheets.sh`, the contents of this "demo" directory will be copied over to the main demo directory of this component.

To create a custom module:

- Choose which component you want to extend with a new module.
- Create a `/var/components/<your_chosen_component>/modules/<module_name> directory.
- Inside the module directory you will normally want to create a `styles.scss` file with your custom styling solutions, but you can create any other file as well.
- It is also possible to create custom demo files for the new module, even if you are extending a core component. You can create you demo files inside `./var/components/<your_chosen_component>/demo/modules/<module_name>` directory. By running `./scripts/compile-demo-stylesheets.sh`, the contents of this "demo" directory will be copied over to the main demo directory of this module.

## Related Project

This project helped generate stylesheets for the [Tagplant.js](https://github.com/TomasBagdanavicius/tagplant.js) project.

# Licensing

Firstile CSS is released under the [MIT License](LICENSE). The build code has no dependencies whatsoever and thus is not dependent upon any 3rd party licensing conditions.