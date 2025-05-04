# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# GrapeJS for page builder
pin "grapesjs", to: "https://ga.jspm.io/npm:grapesjs@0.21.4/dist/grapes.min.js"
pin "grapesjs-blocks-basic", to: "https://ga.jspm.io/npm:grapesjs-blocks-basic@1.0.1/dist/index.js"
pin "grapesjs-preset-webpage", to: "https://ga.jspm.io/npm:grapesjs-preset-webpage@1.0.2/dist/index.js"

# Editor specific JS
pin "grapesjs-editor", to: "grapesjs-editor.js", preload: true
