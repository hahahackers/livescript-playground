require! react: { use-state, use-effect, create-element: $, Fragment }: React
require! 'react-dom': { render }
require! 'react-ace': { default: Ace-Editor }
require! 'ace-builds/src-noconflict/mode-livescript'
require! 'ace-builds/src-noconflict/mode-javascript'
require! 'ace-builds/src-noconflict/theme-solarized_light'
require! 'lodash.rearg': rearg
require! 'lodash.debounce': debounce

use-effect = rearg use-effect, [1 0]
debounce = rearg debounce, [1 0]

livescript = window.require 'livescript'
livescript-options =
    bare: true
    header: false

common-props =
    theme: 'solarized_light'
    font-size: 20
    height: '100vh'
    width: '50%'

Application = ->
    [result, set-result] = use-state ''

    update = debounce 500, (code) ->
        local-storage.set-item "__CODE__", code
        set-result try
            livescript.compile code, livescript-options
        catch
            String e

    use-effect [] ->
        update local-storage.get-item "__CODE__"

    $ 'div', style: { display: 'flex' } ,
        $ Ace-Editor, { ...common-props, mode: 'livescript', on-change: update, default-value: local-storage.get-item "__CODE__" }
        $ Ace-Editor, { ...common-props, mode: 'javascript', value: result }

render ($ Application), document.get-element-by-id "app"