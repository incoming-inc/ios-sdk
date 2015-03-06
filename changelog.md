---
title: Release Notes
layout: default 
---
 

# Version 1.2.7 (March 4, 2015) 

 * Add serendipity to recommendation from content learning to allow the user to discover videos from new topics and genres even after learning.
 * Deep linking into the host application after video playback completes.
 * Various bug fixes:
   * Guard against case where the video storage directory has not been created when performing the file cleanup task.
   * Only set the time downloaded when download completes or fails. It was previously being updated whenever the prefetch status changed.
   * Fix issue where videos with an underscore in the id were treated as if they were orphaned when this was not the case.
   * Add a short backoff when commencing downloads to avoid potential problems if two beoadcasts occur at once (e.g. a duplicate download complete broadcast).
   * Move processing of user presence changes from the UI thread to a worker thread to avoid the risk of ANRs.
