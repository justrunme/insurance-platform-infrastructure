import React from 'react';
import {
  Typography,
  Card,
  CardContent,
  Box,
  Chip,
  Button,
  Grid,
} from '@mui/material';
import { Link } from 'react-router-dom';

const Claims = () => {
  const claims = [
    {
      id: '1',
      claimNumber: 'CLM-2024-001',
      type: 'Auto Insurance',
      status: 'pending',
      amount: '$5,000',
      date: '2024-01-15',
      description: 'Vehicle collision on Highway 101'
    },
    {
      id: '2',
      claimNumber: 'CLM-2024-002',
      type: 'Home Insurance',
      status: 'approved',
      amount: '$2,500',
      date: '2024-01-10',
      description: 'Water damage in basement'
    },
    {
      id: '3',
      claimNumber: 'CLM-2024-003',
      type: 'Health Insurance',
      status: 'pending',
      amount: '$1,200',
      date: '2024-01-08',
      description: 'Emergency room visit'
    },
    {
      id: '4',
      claimNumber: 'CLM-2024-004',
      type: 'Auto Insurance',
      status: 'rejected',
      amount: '$3,200',
      date: '2024-01-05',
      description: 'Windshield replacement'
    },
    {
      id: '5',
      claimNumber: 'CLM-2024-005',
      type: 'Home Insurance',
      status: 'approved',
      amount: '$800',
      date: '2024-01-02',
      description: 'Roof repair after storm'
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
        My Claims
      </Typography>

      <Grid container spacing={3}>
        {claims.map((claim) => (
          <Grid item xs={12} md={6} key={claim.id}>
            <Card>
              <CardContent>
                <Box display="flex" justifyContent="space-between" alignItems="flex-start" sx={{ mb: 2 }}>
                  <Box>
                    <Typography variant="h6" gutterBottom>
                      {claim.claimNumber}
                    </Typography>
                    <Typography color="textSecondary" gutterBottom>
                      {claim.type}
                    </Typography>
                  </Box>
                  <Chip 
                    label={claim.status} 
                    color={getStatusColor(claim.status)}
                    size="small"
                  />
                </Box>

                <Typography variant="body2" color="textSecondary" sx={{ mb: 2 }}>
                  {claim.description}
                </Typography>

                <Box display="flex" justifyContent="space-between" alignItems="center">
                  <Box>
                    <Typography variant="h6" color="primary">
                      {claim.amount}
                    </Typography>
                    <Typography variant="caption" color="textSecondary">
                      Filed: {claim.date}
                    </Typography>
                  </Box>
                  
                  <Button
                    component={Link}
                    to={`/claims/${claim.id}`}
                    variant="outlined"
                    size="small"
                  >
                    View Details
                  </Button>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default Claims; 