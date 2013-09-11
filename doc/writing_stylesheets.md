# Writing Stylesheets

## Using @import

@import is a great feature but easy to mis-use. It does not act like a CSS version of a javascript require, but instead is a way to concatenate stylesheets. Given this you should keep the following things in mind on how to use it.

#### Only @import mixins and variables like components/stylus_lib inside app stylesheets.

The project will package together large stylesheets packages that apps can use. Because multiple apps can use the same components @importing backwards into /components will mean the styles for that component get repeated in a CSS package.

Unfortunately this means it's not very clear what styles are used in an app, but this is necessary to be able to break the stylesheet packages into pieces that are used across all apps and packages that are only necessary for certain apps.

## Writing Class Names and Targeting Elements with CSS

In general there are two simple rules:

1. **ALWAYS** namespace class names. Generic class names are *very bad*.
  
  e.g. Imagine a component called "artwork detail card" that has the image on the left and some of the artwork details on the right.
  
  **Bad**
  
  ````
    section.artwork
      .left
        img
      .right
        h1.artwork-title
        h2.artist-name
  ````
  
  **Good**
  ````
    section.artwork-detail-card
      .artwork-detail-card-left
        img
      .artwork-detail-card-right
        h1.artwork-detail-card-title
        h2.artwork-detail-card-name
  ````
  
  An easy convention to follow is namespace by the component name `.artwork-detail-card-<class name here>` or the <app name>-page and template name `.artwork-page-related-posts-<class name here>`.
  
2. If you do not use a namespace, always scope your tag selectors under a name-spaced element.
  
  e.g. Given the "artwork detail card" component above...
  
  **Bad**
  ````
  .artwork-detail-card
    background #ccc
  img
    width 50%
  ````
  
  **Good**
  ````
  .artwork-detail-card
    background #ccc
    img
      width 50%
  ````

When in doubt just write a new name-spaced class and target that element with the name-spaced class. Follow these two simple rules and you'll have won 90% of the battle.

### Bonus

Following these two simple rules will make it much easier to deal with other CSS pitfalls such as...

* Bloated CSS from mixins and nesting
  * Namespaced classes mean you can just apply classes instead of using mixins
  * If you find yourself nesting too far, you can probably stop nesting because an element further down the chain can just be targeted with a namespaced class and placed at the base level.
* Re-usability of classes
  * Namespaced classes that don't conflict make it clear which combination of them will style an element the way you want.

If you want more detailed reference please see Gib's Awesome Stylesheets synopsis below as well as the [longer blog post that inspired it](http://philipwalton.com/articles/css-architecture/).

> Our CSS is pretty intense. And by intense, I mean bad... not much A.S.S. at all. I'm working on a blog post to highlight some anti-patterns related to SASS specifically (titled "Putting the ASS in SASS!"), but in the mean time, I propose that we follow the guidelines outlined here: http://philipwalton.com/articles/css-architecture/
> 
> Short of a week-ish long project to re-write our SASS, I propose the following: If you're writing new or refactoring SASS components, write class names with a hyphen (e.g. "partner-profile-gallery"). Our current class names use underscores (e.g. "partner_profile"). This will signal that the author followed the architecture guidelines in its creation and that it doesn't need to be killed with fire.
> 
> We can adapt this naming convention once we get started:
> /* Templates Rules */
> %template-name
> %template-name--modifier-name
> %template-name__sub-object
> %template-name__sub-object--modifier-name
> 
> /* Component Rules */
> .component-name
> .component-name--modifier-name
> .component-name__sub-object
> .component-name__sub-object--modifier-name
> 
> /* Layout Rules */
> .l-layout-method
> .grid
> 
> /* State Rules */
> .is-state-type
> 
> /* Non-styled JavaScript Hooks */
> .js-action-name
> 
> Here is the general list of things to avoid:
> Don’t allow IDs in your selectors.
> Avoid coupling to specific markup that may change (ul.menu may become nav.menu).
> Don’t use non-semantic type selectors (e.g. DIV, SPAN) in any multi-part rule.
> Don’t use more than 2 combinators in a selector (ul li a == bad).
> Don’t allow any class names that begin with “js-”.
> Avoid using layout and positioning for non “l-” prefixed rules.
> Avoid generic classnames that could later be redefined as a child of something else.
> 
> Any objections / concerns?