<template>
    <div>
        <div class="header">Working Time</div>
        <WorkingTime></WorkingTime>
    </div>
</template>
  
<script>
import WorkingTime from '../components/admin_workingtime/WorkingTime.vue';
import Line  from '../components/admin_workingtime/WorkingTime.vue';
export default {
    name: 'AdminUserWorkingTime',
    components: {
        WorkingTime,
        Line,
    },
};
</script>
  
<style scoped>
    .header {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: 15px;
    text-align: left;
    }
</style>
  