/* -------------------------------------------------------------------------------------------- *
 * This file contains `require` directives to Javascript files.                                 *
 * All of these Javascript files will be compiled into a single Javascript file.                *
 * To use this combined file, include the following in the head section of your views:          *
 *                                                                                              *
 * <%= manifest :script %>                   If including only application.js                   *
 * <%= manifest :stylesheet, :script %>      If including application.css as well               *
 *                                                                                              *
 * By default, every file in the /assets/scripts directory is required by `require_tree .`      *
 * However, you may remove the `require_tree .` directive and instead specify individual files. *
 *                                                                                              *
 * Any global Javascript code can be included directly in this file.                            *
 * NOTE: JS code defined in this file will be overwritten by JS code written in other files.    *
 * -------------------------------------------------------------------------------------------- *
 *= require_self
 *= require_tree .
 */