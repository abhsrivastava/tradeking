open Js.Json
open Belt.Option
open Belt.Int

let getValue = (json: t, key: string, fn: (t) => option<'a>) : option<'a> => {
  switch json -> classify {
  | JSONObject(obj) => 
    switch obj -> Js.Dict.get(key) {
    | Some(valueObj) => valueObj -> fn
    | None => None
    }
  | _ => None
  }
}

let round = (input: float) => input -> Js.Float.toFixedWithPrecision(~digits=3) -> Js.Float.fromString

let getString = (json, key) => json -> getValue(key, decodeString) -> getExn

let getFloat = (json, key) => json -> getValue(key, decodeNumber) -> getExn -> round

let getInt = (json, key) => json -> getValue(key, decodeNumber) -> map(fromFloat) -> getExn

let getArray = (json, key) => json -> getValue(key, decodeArray) -> getExn

let getValueArray = (json, key, fn: (t) => option<'a>) : array<'a>  => json -> getArray(key) -> Belt.Array.map(json => json -> fn -> getExn)
let getFloatArray = (json, key) => json -> getValueArray(key, decodeNumber) -> Belt.Array.map(round)
let getIntArray = (json, key) => json -> getValueArray(key, x => decodeNumber(x) -> map(fromFloat))
