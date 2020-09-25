import { readable } from "svelte/store";
import { api } from "./api.js";

export const state = readable([], (set) => {
  const onEvent = (data) => {
    let d = data;
    set(d);
    console.log(d[0]);
  };

  api.watchPrimary(onEvent);
});
