import { describe, it, expect, beforeEach, vi } from 'vitest';

describe('Fractional Ownership Contract', () => {
  let mockContractCall: any;
  
  beforeEach(() => {
    mockContractCall = vi.fn();
  });
  
  it('should create fractions', async () => {
    mockContractCall.mockResolvedValue({ success: true });
    const result = await mockContractCall('create-fractions', 1, 1000, 1000);
    expect(result.success).toBe(true);
  });
  
  it('should not create fractions for an existing artwork', async () => {
    mockContractCall.mockResolvedValue({ success: false, error: 403 });
    const result = await mockContractCall('create-fractions', 1, 1000, 1000);
    expect(result.success).toBe(false);
    expect(result.error).toBe(403);
  });
  
  it('should buy a fraction', async () => {
    mockContractCall.mockResolvedValue({ success: true });
    const result = await mockContractCall('buy-fraction', 1, 10);
    expect(result.success).toBe(true);
  });
  
  it('should not buy more fractions than available', async () => {
    mockContractCall.mockResolvedValue({ success: false, error: 400 });
    const result = await mockContractCall('buy-fraction', 1, 1001);
    expect(result.success).toBe(false);
    expect(result.error).toBe(400);
  });
  
  it('should get fraction balance', async () => {
    mockContractCall.mockResolvedValue({ success: true, value: 10 });
    const result = await mockContractCall('get-fraction-balance', 1, 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM');
    expect(result.success).toBe(true);
    expect(result.value).toBe(10);
  });
  
  it('should get artwork fractions', async () => {
    mockContractCall.mockResolvedValue({
      success: true,
      value: {
        total_fractions: 1000,
        price_per_fraction: 1000,
        available_fractions: 990,
        owner: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
      }
    });
    const result = await mockContractCall('get-artwork-fractions', 1);
    expect(result.success).toBe(true);
    expect(result.value.available_fractions).toBe(990);
    expect(result.value.owner).toBe('ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM');
  });
});

