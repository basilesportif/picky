import { writable } from "svelte/store";

function createApi() {
  const { subscribe, set, update } = writable(new Channel());

  const watchPrimary = (onEvent) => {
    // opens a subscription to /primary
    update((chan) => {
      chan.subscribe(
        window.ship,
        "picky-view",
        "/primary",
        (err) => console.log(`Error watching '/primary': ${err}`),
        (data) => onEvent(data),
        () => console.log("Stopped watching '/primary'")
      );
      return chan;
    });
  };

  const poke = (json) => {
    update((chan) => {
      chan.poke(
        window.ship,
        "picky-view",
        "picky-view-action",
        json,
        () => console.log("Successful poke"),
        (err) => console.log(err)
      );
      return chan;
    });
  };

  const ban = (user) => {
    poke({
      ban: {
        rid: { entity: "~timluc-miptev", name: "the-collapse" },
        user: user,
      },
    });
  };

  return {
    subscribe,
    watchPrimary,
    ban,
  };
}

export const api = createApi();
