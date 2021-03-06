module View.Plot.Type.OneForEachMember exposing (oneForEachMember)

import Colors exposing (colorsList)
import Html as H exposing (Html)
import Plot as P
    exposing
        ( JunkCustomizations
        , PlotSummary
        , Series
        )
import Types exposing (..)
import View.Date as Date
import View.Member as Member
import View.Plot.Junk.Title as Junk
import View.Plot.PlotCustomizations exposing (plotCustomizations)
import View.Plot.Series exposing (series)


oneForEachMember : Model -> Data -> List (Html Msg)
oneForEachMember model data =
    List.map2
        (onePlot model data)
        (colorsList (List.length data))
        (data |> List.sortBy (.localScore >> negate))


onePlot : Model -> Data -> String -> Member -> Html Msg
onePlot model data color member =
    P.viewSeriesCustom
        (plotCustomizations model data (junk data member))
        (seriesList model data color member)
        data


seriesList : Model -> Data -> String -> Member -> List (Series Data Msg)
seriesList model data color member =
    data
        |> List.filter (\m -> m.id == member.id)
        |> List.map (series model data dotOptions True color)


junk : Data -> Member -> PlotSummary -> List (JunkCustomizations Msg)
junk data member _ =
    [ Junk.title (Member.description member) (Date.max data) ]


dotOptions : DotOptions
dotOptions =
    { xLine = True
    , yLine = True
    , xTick = True
    , yTick = True
    , stripedHint = False
    }
