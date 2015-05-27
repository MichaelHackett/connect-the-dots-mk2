Note: No attempt has been made to make any of these test-support classes
KVO-compliant. The properties exposed are usually read-only from the
outside, but the values do change; there just isn't any KVO notification
when those changes occur.

Tests usually read the property values just once and have no need to follow
changes. (They don't care what happens before or after the check.) So adding
KVO support would be a waste of time, and probably never missed. Nonetheless,
this note serves as a reminder of the status and reasoning, should the
question ever come up.
