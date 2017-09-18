Maplink & mapframe prevalence by language and project
=======

[Kartographer](https://www.mediawiki.org/wiki/Extension:Kartographer) is a MediaWiki extension that allows editors to easily add [Wikimedia Maps](https://www.mediawiki.org/wiki/Maps) to articles. Editors (and bots) can add [*maplinks*](https://www.mediawiki.org/wiki/Help:Extension:Kartographer#.3Cmaplink.3E) and [*mapframes*](https://www.mediawiki.org/wiki/Help:Extension:Kartographer#.3Cmapframe.3E_usage) (where possible; refer to the list below) to pages such as places on Wikivoyage, landmarks on Wikipedia, and files on Wikimedia Commons.

A **_maplink_** is a textual link (e.g. often coordinates) that a user can click on to view an interactive, potentially annotated map and is enabled on all Wikivoyage and Wikipedia languages. On Commons, camera coordinates -- which are automatically extracted from EXIF data for photo uploads -- show up as maplinks.

A **_mapframe_** is a static thumbnail of a map that a user can click on to view an interactive, possibly annotated map and is enabled on all Wikivoyage languages but only some Wikipedias. As of September 18th, 2017, the mapframe feature is enabled on the following wikis:

- [Metawiki](https://meta.wikimedia.org/)
- [MediaWiki](https://www.mediawiki.org/)
- [Wikimedia Ukraine](https://ua.wikimedia.org/)
- [Wikivoyage](https://www.wikivoyage.org/) (all languages)
- Wikipedia:
    - [Catalan](https://ca.wikipedia.org/)
    - [Hebrew](https://he.wikipedia.org/)
    - [Russian](https://ru.wikipedia.org/)
    - [Macedonian](https://mk.wikipedia.org/)
    - [French](https://fr.wikipedia.org/)
    - [Finnish](https://fi.wikipedia.org)
    - [Norwegian](https://no.wikipedia.org/)
    - [Swedish](https://sv.wikipedia.org/)
    - [Portuguese](https://pt.wikipedia.org/)
    - [Czech](https://cs.wikipedia.org/)
    - [Basque](https://eu.wikipedia.org/)

Notes
-----

* You can select multiple projects and multiple languages to compare simultaneously. (Hold down Ctrl on Windows or Command on Mac.)
* The language picker will automatically choose "(None)" if you select a non-multilingual project such as Wikimedia Commons.
* If you're interested in the overall metric for a multilingual project such as Wikipedia, make sure only "(None)" is selected in the languages picker. There are multiple aggregation options:
    * __Overall__: divides the total number of articles with a maplink/mapframe by the total number of articles across all languages
    * __Average__: computes the prevalence on a per-language basis and then computes the average of those prevalences
    * __Median__: computes the prevalence on a per-language basis and then computes the median of those prevalences

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/maps/#kartographer_langproj">https://discovery.wmflabs.org/maps/#kartographer_langproj</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDWZ/" title="Wikimedia Maps Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDWZ/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
