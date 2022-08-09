module UI.Backend.Helpers exposing (maybeIfNot)


maybeIfNot : a -> a -> Maybe a
maybeIfNot default value =
    if value == default then
        Nothing

    else
        Just value
