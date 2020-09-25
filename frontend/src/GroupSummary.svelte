<script>
  export let group;
  $: numUsers = group.users.length;
  $: userSummary = numUsers === 1 ? "user" : "users";
  $: totalWeek = group.users.map((u) => u.numWeek).reduce((a, b) => a + b, 0);
  $: groupLink = `#/group/${group.resource.owner}/${group.resource.name}`;
</script>

<style>
  article {
    position: relative;
    padding: 0 0 0.2em 2em;
    border-bottom: 1px solid #eee;
  }
  span.totalWeek {
    padding: 0.1em 0 0 0;
    font-weight: bold;
    font-size: 1.4em;
    color: #000096;
    position: absolute;
    left: 0;
  }
  h2 {
    font-size: 1.5em;
    margin: 0.5em 0;
  }
  span.on {
    font-size: 0.8em;
  }
  a {
    font-size: 1.1em;
    margin: 0.5em 0;
    color: #ff0080;
    text-decoration: none;
  }
  a:visited {
    color: #ff0080;
  }
  a:hover {
    text-decoration: underline;
  }
  p {
    margin: 0 0 0 0;
    font-size: 0.9em;
    color: #a6a6a6;
  }
</style>

<article>
  <span class="totalWeek">{totalWeek}</span>
  <h2>{group.name} <span class="on">on</span> {group.resource.ship}</h2>
  <p>
    <a href="#/group/{group.resource.ship}/{group.resource.name}">
      {numUsers}
      {userSummary}
    </a> on {group.resource.ship}
  </p>
</article>
