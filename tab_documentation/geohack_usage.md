GeoHack feature usage
=======

This tab contains feature usage for [GeoHack](https://www.mediawiki.org/wiki/Toolserver:GeoHack), a Wikimedia interface
to geographic data. The only feature currently being tracked is the opening of a page based around GeoHack, which makes
it less-than-useful for comparisons with other interfaces or tools, but very useful for tracking variation in user behaviour.

Events are sampled at a rate of *1%*.

Outages and inaccuracies
------

* '__A__' (2016-04-15): There was a bug in Maps event logging wherein tracking did not work. It was patched on 17 June 2016. See [T138078](https://phabricator.wikimedia.org/T138078) for more details.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/maps/#geohack_usage">
    http://discovery.wmflabs.org/maps/#geohack_usage
  </a>
</p>
