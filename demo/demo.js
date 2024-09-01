"use strict";

const settingsBar = document.createElement("div");
settingsBar.classList.add("demo-settings-bar");
settingsBar.append(colorModeSwitcher.element);
const storeController = colorMode.defaultLocalStorageStoreController;
storeController.key = "demoColorMode";
colorMode.setCustomStoreController(storeController, { apply: true });
document.body.append(settingsBar);