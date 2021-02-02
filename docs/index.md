# Using Notes Template and MkDocs

For full documentation on MkDocs, visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs gh-deploy` - Build and deploy the documentation pages in Github.
* `mkdocs serve` - Start the live-reloading docs server (locally). This will run on http://127.0.0.1:8000/ by default.
* `mkdocs build` - Build the documentation site (locally).
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## VSCode

If you open a clone of a repo based on the Notes Template in VSCode, you can load it in the available Dev Container.
Doing this provides a ready-to-go toolset for modifying, testing, and publishing your notes.

### VSCode: Tasks

* `Build (Github Pages)` - Build and deploy the documentation in Github
* `Serve` - Start the live-reloading docs server (locally). This will run on http://127.0.0.1:8000/ by default.
* `Build` - Build the documentation site (locally). The contents will be written to `/site/`

## Markdown Content Example

Any Github-compatible markdown can be used and will present largely the same as it would on Github.
For a live example of this, see [Lorem Ipsum](lorem-ipsum.md).

## Code blocks with tabs

=== "Code"

    ```markdown
    Lorem markdownum **tenetur utque nigrantis** tractata o perque color habenas
    silvamque fraxineam nemus: hac Auroram tamen. Caeli alii surgere coniunx nec
    proles illos, *unde vocem*, suam, ac. Facie sunt flebat altissimus iubeo tangit:
    sucos ante tibi spicula, incumbens miseram atris, [est
    ingens](http://www.forsitan.io/) cineres aestuat. Sulphure tecta qui se antiquo,
    fecere coniunx, et non purpureis.
    ```

=== "Render"

    Lorem markdownum **tenetur utque nigrantis** tractata o perque color habenas
    silvamque fraxineam nemus: hac Auroram tamen. Caeli alii surgere coniunx nec
    proles illos, *unde vocem*, suam, ac. Facie sunt flebat altissimus iubeo tangit:
    sucos ante tibi spicula, incumbens miseram atris, [est
    ingens](http://www.forsitan.io/) cineres aestuat. Sulphure tecta qui se antiquo,
    fecere coniunx, et non purpureis.

## Admonition block

!!! example

    This is an admonition block and inside it is a tabbed set of code examples.

    === "Code"
    
        ```markdown
        Lorem markdownum **tenetur utque nigrantis** tractata o perque color habenas
        silvamque fraxineam nemus: hac Auroram tamen. Caeli alii surgere coniunx nec
        proles illos, *unde vocem*, suam, ac. Facie sunt flebat altissimus iubeo tangit:
        sucos ante tibi spicula, incumbens miseram atris, [est
        ingens](http://www.forsitan.io/) cineres aestuat. Sulphure tecta qui se antiquo,
        fecere coniunx, et non purpureis.
        ```
    
    === "Render"
    
        Lorem markdownum **tenetur utque nigrantis** tractata o perque color habenas
        silvamque fraxineam nemus: hac Auroram tamen. Caeli alii surgere coniunx nec
        proles illos, *unde vocem*, suam, ac. Facie sunt flebat altissimus iubeo tangit:
        sucos ante tibi spicula, incumbens miseram atris, [est
        ingens](http://www.forsitan.io/) cineres aestuat. Sulphure tecta qui se antiquo,
        fecere coniunx, et non purpureis.
