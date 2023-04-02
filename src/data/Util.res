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

let getString = (json, key) => json -> getValue(key, decodeString) -> getExn

let getFloat = (json, key)=> json -> getValue(key, decodeNumber) -> getExn

let getInt = (json, key) => json -> getValue(key, decodeNumber) -> map(fromFloat) -> getExn

let getArray = (json, key) => json -> getValue(key, decodeArray) -> getExn
