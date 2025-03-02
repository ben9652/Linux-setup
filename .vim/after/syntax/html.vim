" Resaltar @if y @else como palabras clave
syntax keyword htmlKeyword @if @else
highlight link htmlKeyword Statement

" Resaltar la condición entre paréntesis después de @if
syntax match htmlAngularIf "@if\s*(.*)\s*{" contains=htmlTag,htmlEndTag,htmlString,htmlComment
highlight link htmlAngularIf Special

syntax match htmlAngularIf "@else if\s*(.*)\s*{" contains=htmlTag,htmlEndTag,htmlString,htmlComment
highlight link htmlAngularIf Special

syntax match htmlAngularIf "@else\s*{" contains=htmlTag,htmlEndTag,htmlString,htmlComment
highlight link htmlAngularIf Special

" Resaltar el bloque entre llaves después de @if o @else
syntax region htmlAngularBlock start="{" end="}" containedin=htmlAngularIf,htmlKeyword contains=htmlTag,htmlEndTag,htmlString,htmlComment
highlight link htmlAngularBlock Function

" Opcional: Resaltar paréntesis y llaves para mejor visibilidad
syntax match htmlAngularParenthesis "[()]"
highlight link htmlAngularParenthesis Delimiter

syntax match htmlAngularBraces "[{}]"
highlight link htmlAngularBraces Delimiter

" Permite que los elementos con guiones se reconozcan como etiquetas HTML
syntax clear htmlTagName
syntax match htmlTagName contained "\<[a-zA-Z][a-zA-Z0-9-]*\>"

" Propiedades normales (sin binding)
hi link htmlArg Type  " Color para todas las propiedades

" Valores de propiedades con [ ] o [()]
syntax region angularPropValue matchgroup=Operator start=/\[\%(\w\|-\)\+\]\s*=\zs"/ end=/"/ containedin=htmlTag contained contains=@htmlStringContents
syntax region angularTwoWayValue matchgroup=Operator start=/\[(\%(\w\|-\)\+)\]\s*=\zs"/ end=/"/ containedin=htmlTag contained contains=@htmlStringContents

" Valores de propiedades con ( )
syntax region angularEventValue matchgroup=Operator start=/(\%(\w\|-\)\+)\s*=\zs"/ end=/"/ containedin=htmlTag contained contains=@htmlStringContents

" Asignar colores a los valores
hi def angularPropValue guifg=#FFA500  " Naranja para [prop]
hi def angularTwoWayValue guifg=#00FFFF " Cyan para [(twoWay)]
hi def angularEventValue guifg=#98FB98  " Verde claro para (event)


