<script>
  import { onMount } from "svelte";
  import Message from "./Message.svelte";
  import { api } from "./api.js";

  export let group;
  export let homeRoute;
  export let ownRoute;
  $: sortedUsers = group.users.sort((a, b) => a.numWeek <= b.numWeek);
  let user = null;
  let numMsgs = 10;
  $: userMsgs = user ? msgs[user.name].slice(0, numMsgs) : [];

  let msgs = {
    "~locbur-pasneb": [],
    "~tirlyd-tadlug": [{ when: "2020-04-25", text: "I'm cool" }],
    "~fabnev-hinmur": [
      { when: "2020-08-26", text: "your mom" },
      { when: "2020-08-27", text: "political stuff" },
    ],
  };

  // does the user fetch in here
  /*
  $: fetch(`localhost=${page}`, {
    method: "POST",
    body: `password=${pass}`,
  })
    .then((r) => r.json())
    .then((data) => {
      items = data;
      offset = PAGE_SIZE * (page - 1);
      window.scrollTo(0, 0);
    });
    */

  const setUser = (u) => (user = u);
  const banUser = (u) => {
    api.banUser(u.name);
    console.log(`%ban ${u.name}`);
  };
</script>

<style>
  a {
    font-size: 1.1em;
    margin: 0.5em 0;
    color: #000096;
    text-decoration: none;
  }
  a:visited {
    color: #000096;
  }
  a:hover {
    text-decoration: underline;
    font-weight: 400;
  }
  div.container {
    width: 700px;
    display: grid;
    grid-template-columns: 40% auto;
  }
  header {
    color: #ff0080;
    font-size: 1.2em;
  }
  a.selected {
    color: #ff0080;
  }
  article.user {
    position: relative;
    padding: 0.5em 0.2em 0.2em 0em;
    border-bottom: 1px solid #eee;
  }
  div.msgs {
    padding: 0em 0em 0em 0.9em;
  }
  button.ban {
    float: right;
    font-size: 0.6em;
    margin-right: 0.2em;
  }
</style>

<a href={homeRoute}>« Home</a>
<h2>{group.name}</h2>
<div class="container">
  <div>
    <header>Users</header>
    {#each group.users as u, i}
      <article class="user">
        <a
          class={u === user ? 'selected' : ''}
          href={ownRoute}
          on:click|preventDefault={setUser(u)}>
          {u.name}: {u.numWeek}, {u.numMonth}
        </a>
        {#if u === user}
          <button class="ban" on:click={banUser(u)}>Ban</button>
        {/if}
      </article>
    {/each}
  </div>
  <div class="msgs">
    <header>Messages</header>
    {#if user}
      {#each userMsgs as um}
        <Message message={um} />
      {/each}
    {:else}Click a user to view their {numMsgs} most recent messages{/if}
  </div>
</div>
