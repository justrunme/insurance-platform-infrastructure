import React from 'react';
import {
  Typography,
  Grid,
  Card,
  CardContent,
  Box,
  Chip,
} from '@mui/material';

const Dashboard = () => {
  const stats = {
    totalClaims: 5,
    pendingClaims: 2,
    approvedClaims: 2,
    rejectedClaims: 1,
  };

  const recentClaims = [
    {
      id: 'CLM-2024-001',
      type: 'Auto Insurance',
      status: 'pending',
      amount: '$5,000',
      date: '2024-01-15'
    },
    {
      id: 'CLM-2024-002', 
      type: 'Home Insurance',
      status: 'approved',
      amount: '$2,500',
      date: '2024-01-10'
    },
    {
      id: 'CLM-2024-003',
      type: 'Health Insurance', 
      status: 'pending',
      amount: '$1,200',
      date: '2024-01-08'
    }
  ];

  const getStatusColor = (status) => {
    switch (status) {
      case 'approved': return 'success';
      case 'pending': return 'warning';
      case 'rejected': return 'error';
      default: return 'default';
    }
  };

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Dashboard
      </Typography>

      {/* Statistics Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Typography color="textSecondary" gutterBottom>
                Total Claims
              </Typography>
              <Typography variant="h5">
                {stats.totalClaims}
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Typography color="textSecondary" gutterBottom>
                Pending Claims
              </Typography>
              <Typography variant="h5" color="warning.main">
                {stats.pendingClaims}
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Typography color="textSecondary" gutterBottom>
                Approved Claims
              </Typography>
              <Typography variant="h5" color="success.main">
                {stats.approvedClaims}
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card>
            <CardContent>
              <Typography color="textSecondary" gutterBottom>
                Rejected Claims
              </Typography>
              <Typography variant="h5" color="error.main">
                {stats.rejectedClaims}
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Recent Claims */}
      <Card>
        <CardContent>
          <Typography variant="h6" gutterBottom>
            Recent Claims
          </Typography>
          <Grid container spacing={2}>
            {recentClaims.map((claim) => (
              <Grid item xs={12} key={claim.id}>
                <Card variant="outlined">
                  <CardContent>
                    <Box display="flex" justifyContent="space-between" alignItems="center">
                      <Box>
                        <Typography variant="subtitle1">
                          {claim.id}
                        </Typography>
                        <Typography color="textSecondary">
                          {claim.type} • {claim.date}
                        </Typography>
                      </Box>
                      <Box display="flex" alignItems="center" gap={2}>
                        <Typography variant="h6">
                          {claim.amount}
                        </Typography>
                        <Chip 
                          label={claim.status} 
                          color={getStatusColor(claim.status)}
                          size="small"
                        />
                      </Box>
                    </Box>
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
        </CardContent>
      </Card>
    </Box>
  );
};

export default Dashboard; 