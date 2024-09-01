import FileSystem from "fs";
import Path from "path";
import postcss from "postcss";
import cssnano from "cssnano";
import * as sass from "sass";

const distPath = Path.join(import.meta.dirname, "/../dist");
const srcPath = Path.join(import.meta.dirname, "/../src");
const varPath = Path.join(import.meta.dirname, "/../var");

// Custom plugin to remove empty @layer rules
const removeEmptyLayers = () => {
    return {
        postcssPlugin: "remove-empty-layers",
        OnceExit(root) {
            root.walkAtRules("layer", atRule => {
                if (atRule.nodes && atRule.nodes.length === 0) {
                    atRule.remove();
                }
            });
        }
    };
};
// Assign postcssPlugin to enable PostCSS to recognize this as a plugin
removeEmptyLayers.postcss = true;

const removeUnusedLayers = () => {
    return {
        postcssPlugin: "remove-unused-layers",
        OnceExit(root) {
            const usedLayers = new Set();
            root.walkAtRules("layer", atRule => {
                if (atRule.nodes && atRule.nodes.length > 0) {
                    usedLayers.add(atRule.params);
                }
            });
            // Walk through the top @layer rule
            root.walkAtRules("layer", atRule => {
                if (atRule.parent === root && !atRule.nodes) {
                    // Split the layers into an array
                    const layerList = atRule.params.split(",").map(layer => layer.trim());
                    // Filter out unused layers
                    const filteredLayers = layerList.filter(layer => usedLayers.has(layer));
                    if (filteredLayers.length > 0) {
                        // Update the @layer rule with the filtered list
                        atRule.params = filteredLayers.join(", ");
                    } else {
                        // If no layers are used, remove the @layer rule entirely
                        atRule.remove();
                    }
                }
            });
        }
    };
};

// Assign postcssPlugin to enable PostCSS to recognize this as a plugin
removeUnusedLayers.postcss = true;

function emptyDir(path) {
    const files = FileSystem.readdirSync(path);
    for (const file of files) {
        FileSystem.rmSync(
            Path.join(path, file), {
                recursive: true,
                force: true
            }
        );
    }
}

function changeFileExtension(filePath, newExtension) {
    const parsedPath = Path.parse(filePath);
    parsedPath.ext = newExtension.startsWith(".") ? newExtension : `.${newExtension}`;
    parsedPath.base = parsedPath.name + parsedPath.ext;
    return Path.format(parsedPath);
}

async function minifyCss(code, { isRemoveEmptyLayers = true, isRemoveUnusedLayers = true } = {}) {
    const tasks = [
        cssnano({ preset: "default" }),
    ];
    if (isRemoveEmptyLayers) {
        tasks.push(removeEmptyLayers());
    }
    if (isRemoveUnusedLayers) {
        tasks.push(removeUnusedLayers());
    }
    return await postcss(tasks).process(code, {
        from: undefined
    }).then(result => {
        return result.css;
    });
}

emptyDir(distPath);

const config = {
    removeEmptyLayers: true,
    removeUnusedLayers: true,
    sourceMap: true,
};
const args = process.argv.slice(2);
args.forEach(arg => {
    const [key, value] = arg.split("=");
    if (value === "0") {
        config[key] = false;
    } else {
        config[key] = !!value;
    }
});

// Read the contents of the directory
const stylesheetsSourcePath = Path.join(varPath, "stylesheets");
const files = FileSystem.readdirSync(stylesheetsSourcePath);
// Loop through each file
for (const file of files) {
    if (!file.startsWith("_") && file.endsWith(".scss")) {
        const inputPath = Path.join(stylesheetsSourcePath, file);
        const outputPath = Path.join(distPath, changeFileExtension(file, "css"));
        const parsedPath = Path.parse(file);
        const minFileName = `${parsedPath.name}.min.css`;
        // Compile Sass
        const compiled = sass.compile(inputPath, {
            sourceMap: config.sourceMap,
        });
        let output = compiled.css;
        if (compiled.sourceMap) {
            const mapFilePath = `${outputPath}.map`;
            FileSystem.writeFileSync(mapFilePath, JSON.stringify(compiled.sourceMap));
            const sourceMappingURLComment = `\n\n/*# sourceMappingURL=${Path.basename(mapFilePath)} */\n`;
            output = output.concat(sourceMappingURLComment);
        }
        FileSystem.writeFileSync(outputPath, output);
        const minifiedCSSCode = await minifyCss(compiled.css, {
            isRemoveEmptyLayers: config.removeEmptyLayers,
            isRemoveUnusedLayers: config.removeUnusedLayers,
        });
        FileSystem.writeFileSync(Path.join(distPath, minFileName), minifiedCSSCode);
    }
}