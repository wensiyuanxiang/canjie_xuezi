export class ComboSystem {
  private combo = 0;

  private maxCombo = 0;

  increment(): number {
    this.combo += 1;
    this.maxCombo = Math.max(this.maxCombo, this.combo);
    return this.combo;
  }

  reset(): void {
    this.combo = 0;
  }

  getCombo(): number {
    return this.combo;
  }

  getMaxCombo(): number {
    return this.maxCombo;
  }

  isEmpowered(): boolean {
    return this.combo >= 3;
  }
}
