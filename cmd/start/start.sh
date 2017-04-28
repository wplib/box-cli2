if isGuest ; then
    stdErr "'box start' is a host-only command."
else
    stdOut "Starting WPLib Box..."
    #vagrant up
fi