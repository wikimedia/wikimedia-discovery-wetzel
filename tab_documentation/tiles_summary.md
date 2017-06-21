Tiles (Summary)
=======

The initial usage spike was due to the announcement of the mapping service to the development community, and not the regular usage by Wikipedia users. Once the initial interest subsided, the usage fell back to the expected pre-announcement levels.

Notes
-----

- From 2015-11-01 to 2015-11-10 stress-testing traffic made its way into this data; this has now been removed.
* '__A__' (2015-09-17): Maps launch announced
* '__B__' (2016-01-08): Maps launched on en.wikipedia.org
* '__C__' (2016-01-12): Maps launch on en.wikipedia.org reverted on the 9th; caches begin to clear
* '__D__' (2016-11-09): Pokemon Go fan site Pkget switched to using our tiles after getting [blocked from tile.osm.org](https://github.com/openstreetmap/chef/commit/dece06b6) on 2016-11-08 (see [T154717](https://phabricator.wikimedia.org/T154717) for more details)
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/maps/#tiles_summary">https://discovery.wmflabs.org/maps/#tiles_summary</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDWZ/" title="Wikimedia Maps Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDWZ/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
