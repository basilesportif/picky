<script>
  import GroupSummary from "./GroupSummary.svelte";
  export let groups = [];
</script>

<style>
</style>

{#each groups as group}
  <GroupSummary {group} />
{/each}
