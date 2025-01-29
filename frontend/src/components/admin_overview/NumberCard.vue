<template>
  <div
    class="statistic-card"
    :style="cardStyle"
  >
    <div class="card-content">
      <div class="card-content-col-1">
        <span class="title">{{ title }}</span>
        <span class="unit-number">{{ number }} {{ unit }}</span>
      </div>
      <div class="card-content-col-2">
        <img :src="iconSrc" alt="icon" class="icon" />
        <span class="percentage">{{ percentage }}%</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'StatisticCard',
  props: {
    id: Number,
    title: String,
    number: String,
    unit: String,
    percentage: Number,
  },
  computed: {
    iconSrc() {
      return require(`@/assets/icons/${this.percentage > 0 ? 'up' : 'down'}.png`);
    },
    cardStyle() {
      return {
        backgroundColor: this.id == 1 ? '#8fb67d': '#fff',
        color:  this.id == 1 ? 'white' : 'black',
      };
    },
  },
};
</script>

<style scoped>
.statistic-card {
  padding: 1vw;
  border: 1px solid #e0e0e0;
  border-radius: 15px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.card-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 0.5vw;
}

.card-content-col-1 {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 0.5vw;
}

.card-content-col-2 {
  display: flex;
  flex-direction: column;
}

.title {
  font-size: 1.3vw;
  /* font-weight: bold; */
}

.unit-number {
  font-size: 2.1vw;
}

.icon {
  width: 2.5vw;
  height: 2.5vw;
}

.percentage {
  font-size: 1.3vw;
}
</style>
