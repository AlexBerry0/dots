import { Bar } from "./bar.js"
import { applauncher } from "./applauncher.js"

const scss = `./style.scss`
const css = `/tmp/ags/style.css`
Utils.exec(`sassc ${scss} ${css}`)


App.config({
    style: css,
    windows: [
        Bar(),
        applauncher

    ],
})

